-- ANONYMIZE -- clean, testable migration backup
--
-- Applied by migration.sh (export_backup) with the anonymize command. It runs
-- against the THROWAWAY sandbox database the script restored from the SOURCE
-- backup, never against a production database.
--
-- Goal: a migrated .zip that can be uploaded to a test Odoo instance without
-- any chance the instance sends real mail, keeps a real credential, or exposes
-- real contact data:
--   1. delete the outgoing/incoming mail infrastructure (ir.mail_server,
--      fetchmail.server, mail.gateway allow-list, push tokens) and any
--      still-queued mail_mail rows,
--   2. drop the ir.config_parameter keys that carry SMTP/fetchmail/catchall
--      secrets and the enforced 2FA policy, and reset web.base.url to a local
--      placeholder,
--   3. rewrite every stored e-mail address deterministically to id-based
--      @sandbox.local values, rewrite personal names, and null every phone,
--      address, tax id, bank account and other identifier,
--   4. remove every 2FA secret / TOTP device / API key and disable the forced
--      two-factor policy,
--   5. reset every user password to the documented test value and expose a
--      single, known administrator login ("admin").
--
-- Idempotent: safe to run more than once on the same sandbox.
--
-- The rewrite phase is per-table AND per-column guarded (information_schema /
-- to_regclass) because columns drift between Odoo versions and modules:
--   * res_partner.mobile is absent in 19.0;
--   * res_users.email exists in 18.0 but not in 19.0;
--   * res_users.totp_secret holds the real 2FA seed in 19.0;
--   * hr identification/passport/private_* fields moved to hr_version in 19.0;
--   * mail_message has no `headers` column in 19.0;
--   * crm.lead.email was renamed, hr.applicant moved to hr_recruitment.
-- A missing table or column is skipped, never an error, so the file is
-- deliberately over-broad: keeping an extra candidate in a list is free.
--
-- Translated character columns (res_partner.name, res_company.name, ...) are
-- stored as jsonb. The name rewrite mirrors the existing shape (jsonb object
-- -> object with the same language keys, scalar -> scalar) so it cannot corrupt
-- a translatable field.
--
-- Free-text mail content is kept but every embedded e-mail address is scrubbed
-- in place (mail_message.body/subject, mail_template.subject/body_html,
-- mail_tracking_value.old/new_value_char/text) so the migration test still has
-- text to render while no real address survives. Deliberately NOT rewritten:
-- e-mail Message-Ids (routing keys, not addresses) and everything in the
-- filestore (ir.attachment images / documents); treat a migrated sandbox as
-- untrusted for those regardless.
--
-- The password hash below is passlib pbkdf2_sha512 (Odoo's _crypt_context
-- scheme) for the string "test". Regenerate for another value with:
--   docker run --rm --entrypoint python3 openupgrade-19.0 python3 -c \
--     "from passlib.context import CryptContext; \
--      print(CryptContext(schemes=['pbkdf2_sha512']).hash('PASSWORD'))"

-- 1. mail infrastructure ------------------------------------------------------
DO $anonymize$
BEGIN
  IF to_regclass('ir_mail_server')       IS NOT NULL THEN DELETE FROM ir_mail_server;       END IF;
  IF to_regclass('fetchmail_server')     IS NOT NULL THEN DELETE FROM fetchmail_server;     END IF;
  IF to_regclass('mail_mail')            IS NOT NULL THEN DELETE FROM mail_mail;            END IF;
  IF to_regclass('mail_tracking_email')  IS NOT NULL THEN DELETE FROM mail_tracking_email;  END IF;
  IF to_regclass('mail_blacklist')       IS NOT NULL THEN DELETE FROM mail_blacklist;       END IF;
  IF to_regclass('mail_gateway_allowed') IS NOT NULL THEN DELETE FROM mail_gateway_allowed;  END IF;
  IF to_regclass('mail_push_device')     IS NOT NULL THEN DELETE FROM mail_push_device;     END IF;
END
$anonymize$;

-- 2. system parameters --------------------------------------------------------
-- Includes the 2FA policy: with auth_totp_mail installed, auth_totp.policy set
-- to employee_required/all_required forces an e-mail one-time code to every
-- login (and fails when SMTP is gone). Clearing the key (as Odoo itself does on
-- "disable") removes the prompt entirely.
DELETE FROM ir_config_parameter
 WHERE key ILIKE 'mail.%'
    OR key ILIKE '%smtp%'
    OR key ILIKE 'fetchmail%'
    OR key ILIKE 'auth_totp%';

INSERT INTO ir_config_parameter (key, value) VALUES
  ('web.base.url', 'http://localhost:8069')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

-- 3. mail alias domains -> sandbox-<id>.local ---------------------------------
-- A per-row domain keeps the UNIQUE(bounce_alias, name) /
-- UNIQUE(catchall_alias, name) constraints satisfied even when several
-- domains share the default bounce/catchall aliases.
DO $anonymize$
BEGIN
  IF to_regclass('mail_alias') IS NOT NULL THEN
    EXECUTE 'UPDATE mail_alias SET alias_defaults = ''{}'' WHERE alias_defaults <> ''{}''';
    IF EXISTS (SELECT 1 FROM information_schema.columns
                WHERE table_name = 'mail_alias' AND column_name = 'alias_bounced_content') THEN
      EXECUTE 'UPDATE mail_alias SET alias_bounced_content = NULL WHERE alias_bounced_content IS NOT NULL';
    END IF;
  END IF;

  IF to_regclass('mail_alias_domain') IS NOT NULL THEN
    EXECUTE 'UPDATE mail_alias_domain SET name = ''sandbox-'' || id || ''.local'' WHERE name NOT LIKE ''sandbox-%''';

    IF to_regclass('mail_alias') IS NOT NULL
       AND EXISTS (SELECT 1 FROM information_schema.columns
                    WHERE table_name = 'mail_alias' AND column_name = 'alias_full_name') THEN
      EXECUTE 'UPDATE mail_alias
                  SET alias_full_name = CASE
                        WHEN alias_name IS NULL THEN NULL
                        WHEN alias_domain_id IS NULL THEN alias_name
                        ELSE alias_name || ''@sandbox-'' || alias_domain_id || ''.local''
                      END';
    END IF;
  END IF;
END
$anonymize$;

-- 4. deterministic identifier rewrite -----------------------------------------
DO $anonymize$
DECLARE
  tbl  text;
  col  text;
  prefix text;
  typ  text;
  re   text := '[A-Za-z0-9._%+-]+@[A-Za-z0-9._-]+\.[A-Za-z]{2,}';
BEGIN
  -- 4a. e-mail addresses -> <prefix><id>@sandbox.local
  FOR tbl, col, prefix IN
    SELECT * FROM (VALUES
      ('res_partner',       'email',            'partner'),
      ('res_partner',       'email_normalized', 'partner'),
      ('res_users',         'email',            'user'),
      ('crm_lead',          'email_from',       'lead'),
      ('crm_lead',          'email_normalized', 'lead'),
      ('crm_lead',          'email',            'lead'),
      ('hr_applicant',      'email_from',       'applicant'),
      ('hr_applicant',      'email_normalized', 'applicant'),
      ('hr_applicant',      'email',            'applicant'),
      ('hr_employee',       'work_email',       'employee'),
      ('hr_employee',       'private_email',    'employee'),
      ('hr_version',        'work_email',       'employee'),
      ('hr_version',        'private_email',    'employee'),
      ('resource_resource', 'email',            'resource'),
      ('mailing_contact',   'email',            'contact'),
      ('mailing_mailing',   'email_from',       'mailing'),
      ('mailing_mailing',   'reply_to',         'mailing'),
      ('mail_message',      'email_from',       'mail'),
      ('mail_message',      'reply_to',         'mail'),
      ('mail_group_member', 'email',            'groupmember'),
      ('mail_group_member', 'email_normalized', 'groupmember')
    ) AS v(tbl, col, prefix)
  LOOP
    IF EXISTS (SELECT 1 FROM information_schema.columns
                WHERE table_name = tbl AND column_name = col) THEN
      EXECUTE format(
        'UPDATE %I SET %I = %L || id || ''@sandbox.local'' WHERE %I IS NOT NULL',
        tbl, col, prefix, col);
    END IF;
  END LOOP;

  -- 4b. personal names -> <prefix><id> (mirror jsonb shape when translated)
  FOR tbl, col, prefix IN
    SELECT * FROM (VALUES
      ('res_partner',       'name',          'partner'),
      ('res_partner',       'complete_name', 'partner'),
      ('res_company',       'name',          'company'),
      ('hr_employee',       'name',          'employee'),
      ('resource_resource', 'name',          'resource'),
      ('mailing_contact',   'name',          'contact'),
      ('calendar_attendee', 'common_name',   'attendee')
    ) AS v(tbl, col, prefix)
  LOOP
    IF EXISTS (SELECT 1 FROM information_schema.columns
                WHERE table_name = tbl AND column_name = col) THEN
      IF (SELECT data_type FROM information_schema.columns
           WHERE table_name = tbl AND column_name = col) = 'jsonb' THEN
        EXECUTE format(
          'UPDATE %I SET %I = CASE jsonb_typeof(%I)
             WHEN ''object'' THEN COALESCE(
               (SELECT jsonb_object_agg(k, to_jsonb(%L || id))
                  FROM jsonb_object_keys(%I) AS k),
               to_jsonb(%L || id))
             ELSE to_jsonb(%L || id)
           END
           WHERE %I IS NOT NULL',
          tbl, col, col, prefix, col, prefix, prefix, col);
      ELSE
        EXECUTE format(
          'UPDATE %I SET %I = %L || id WHERE %I IS NOT NULL',
          tbl, col, prefix, col);
      END IF;
    END IF;
  END LOOP;

  -- 4c. phone / address / tax / bank / other identifiers -> NULL
  FOR tbl, col IN
    SELECT * FROM (VALUES
      ('res_partner',       'phone'),
      ('res_partner',       'mobile'),
      ('res_partner',       'street'),
      ('res_partner',       'street2'),
      ('res_partner',       'zip'),
      ('res_partner',       'city'),
      ('res_partner',       'vat'),
      ('res_partner',       'company_registry'),
      ('res_partner',       'website'),
      ('res_partner',       'comment'),
      ('res_partner',       'function'),
      ('res_partner',       'ref'),
      ('res_partner',       'company_name'),
      ('res_partner',       'barcode'),
      ('res_partner',       'partner_latitude'),
      ('res_partner',       'partner_longitude'),
      ('res_company',       'email'),
      ('res_company',       'phone'),
      ('res_company',       'website'),
      ('res_company',       'vat'),
      ('res_company',       'company_registry'),
      ('crm_lead',          'phone'),
      ('crm_lead',          'mobile'),
      ('crm_lead',          'street'),
      ('crm_lead',          'street2'),
      ('crm_lead',          'zip'),
      ('crm_lead',          'city'),
      ('crm_lead',          'website'),
      ('crm_lead',          'function'),
      ('crm_lead',          'referred'),
      ('crm_lead',          'description'),
      ('crm_lead',          'contact_name'),
      ('crm_lead',          'partner_name'),
      ('hr_applicant',      'partner_name'),
      ('hr_applicant',      'partner_phone'),
      ('hr_applicant',      'partner_phone_sanitized'),
      ('hr_applicant',      'partner_mobile'),
      ('hr_applicant',      'linkedin_profile'),
      ('hr_applicant',      'applicant_notes'),
      ('hr_applicant',      'description'),
      ('hr_employee',       'work_phone'),
      ('hr_employee',       'mobile_phone'),
      ('hr_employee',       'private_phone'),
      ('hr_employee',       'emergency_phone'),
      ('hr_employee',       'emergency_contact'),
      ('hr_employee',       'private_car_plate'),
      ('hr_employee',       'permit_no'),
      ('hr_employee',       'visa_no'),
      ('hr_employee',       'visa_expire'),
      ('hr_employee',       'work_permit_expiration_date'),
      ('hr_employee',       'work_permit_name'),
      ('hr_employee',       'has_work_permit'),
      ('hr_employee',       'legal_name'),
      ('hr_employee',       'place_of_birth'),
      ('hr_employee',       'birthday'),
      ('hr_employee',       'certificate'),
      ('hr_employee',       'study_field'),
      ('hr_employee',       'study_school'),
      ('hr_employee',       'identification_id'),
      ('hr_employee',       'passport_id'),
      ('hr_employee',       'barcode'),
      ('hr_employee',       'pin'),
      ('hr_employee',       'id_card'),
      ('hr_employee',       'driving_license'),
      ('hr_employee',       'employee_properties'),
      ('hr_version',        'identification_id'),
      ('hr_version',        'ssnid'),
      ('hr_version',        'passport_id'),
      ('hr_version',        'passport_expiration_date'),
      ('hr_version',        'private_street'),
      ('hr_version',        'private_street2'),
      ('hr_version',        'private_city'),
      ('hr_version',        'private_zip'),
      ('hr_version',        'private_phone'),
      ('hr_version',        'spouse_complete_name'),
      ('hr_version',        'spouse_birthdate'),
      ('hr_version',        'children'),
      ('hr_version',        'departure_description'),
      ('hr_version',        'additional_note'),
      ('hr_version',        'distance_home_work'),
      ('hr_version',        'km_home_work'),
      ('resource_resource', 'email'),
      ('mailing_contact',   'first_name'),
      ('mailing_contact',   'last_name'),
      ('mailing_contact',   'company_name'),
      ('mail_message',      'incoming_email_to'),
      ('mail_message',      'incoming_email_cc'),
      ('mail_message',      'outgoing_email_to'),
      ('sms_sms',           'number'),
      ('sms_sms',           'body'),
      ('res_partner_bank',  'acc_number'),
      ('res_partner_bank',  'acc_holder_name'),
      ('res_partner_bank',  'sanitized_acc_number'),
      ('calendar_attendee', 'phone'),
      ('res_users',         'signature')
    ) AS v(tbl, col)
  LOOP
    IF EXISTS (SELECT 1 FROM information_schema.columns
                WHERE table_name = tbl AND column_name = col) THEN
      EXECUTE format('UPDATE %I SET %I = NULL WHERE %I IS NOT NULL', tbl, col, col);
    END IF;
  END LOOP;

  -- 4d. company display name follows its (already scrubbed) partner
  IF (SELECT data_type FROM information_schema.columns
       WHERE table_name = 'res_company' AND column_name = 'name')
     = (SELECT data_type FROM information_schema.columns
         WHERE table_name = 'res_partner' AND column_name = 'name') THEN
    EXECUTE 'UPDATE res_company c
                SET name = p.name
               FROM res_partner p
              WHERE p.id = c.partner_id AND p.name IS NOT NULL';
  END IF;

  -- 4e. scrub e-mail addresses embedded in free text --------------------------
  -- Keeps the message readable for the migration test but removes every real
  -- address. Template placeholders (${object.email}) do not match and stay.
  -- Odoo 17+ stores translatable Html/Char fields (mail_template.body_html,
  -- mail_template.subject) as jsonb, so cast those through text and back.
  FOR tbl, col IN
    SELECT * FROM (VALUES
      ('mail_message',        'body'),
      ('mail_message',        'subject'),
      ('mail_template',       'body_html'),
      ('mail_template',       'subject'),
      ('mail_template',       'email_from'),
      ('mail_template',       'email_to'),
      ('mail_template',       'partner_to'),
      ('mail_template',       'email_cc'),
      ('mail_template',       'reply_to'),
      ('mail_tracking_value', 'old_value_char'),
      ('mail_tracking_value', 'old_value_text'),
      ('mail_tracking_value', 'new_value_char'),
      ('mail_tracking_value', 'new_value_text')
    ) AS v(tbl, col)
  LOOP
    SELECT data_type INTO typ
      FROM information_schema.columns
     WHERE table_name = tbl AND column_name = col;
    IF typ IS NULL THEN
      CONTINUE;  -- column absent in this Odoo version
    END IF;
    IF typ = 'jsonb' THEN
      EXECUTE format(
        'UPDATE %I SET %I = regexp_replace(%I::text, %L, %L, ''gi'')::jsonb WHERE %I::text ~ %L',
        tbl, col, col, re, 'redacted@sandbox.local', col, re);
    ELSE
      EXECUTE format(
        'UPDATE %I SET %I = regexp_replace(%I::text, %L, %L, ''gi'') WHERE %I::text ~ %L',
        tbl, col, col, re, 'redacted@sandbox.local', col, re);
    END IF;
  END LOOP;
END
$anonymize$;

-- 5. credentials: TOTP secrets, trusted devices, API keys, login log ----------
DO $anonymize$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
              WHERE table_name = 'res_users' AND column_name = 'totp_secret') THEN
    EXECUTE 'UPDATE res_users SET totp_secret = NULL WHERE totp_secret IS NOT NULL';
  END IF;
  IF EXISTS (SELECT 1 FROM information_schema.columns
              WHERE table_name = 'res_users' AND column_name = 'totp_last_counter') THEN
    EXECUTE 'UPDATE res_users SET totp_last_counter = 0 WHERE totp_last_counter <> 0';
  END IF;
  IF to_regclass('auth_totp_device')         IS NOT NULL THEN DELETE FROM auth_totp_device;         END IF;
  IF to_regclass('auth_totp_rate_limit_log') IS NOT NULL THEN DELETE FROM auth_totp_rate_limit_log; END IF;
  IF to_regclass('res_users_apikeys')        IS NOT NULL THEN DELETE FROM res_users_apikeys;        END IF;
  IF to_regclass('res_users_log')            IS NOT NULL THEN DELETE FROM res_users_log;            END IF;
END
$anonymize$;

-- 6. user logins: deterministic, one known administrator ----------------------
-- Odoo's own accounts (root, admin, public / portal templates, demo users) are
-- identified by the base xmlids AND by their well-known logins ("default",
-- "public", "portaltemplate"): they are not real people and other code resolves
-- them by xmlid or by login, so their login is left untouched. Every other
-- login is rewritten to a deterministic value; the admin is then exposed as
-- "admin" so the sandbox is reachable.
DO $anonymize$
DECLARE
  admin_id     integer;
  internal_ids integer[];
BEGIN
  SELECT array_agg(res_id) INTO internal_ids
    FROM ir_model_data
   WHERE module = 'base' AND model = 'res.users'
     AND name IN ('user_root', 'user_admin', 'public_user',
                  'template_portal_user_id', 'user_demo', 'user_light');

  SELECT res_id INTO admin_id
    FROM ir_model_data
   WHERE module = 'base' AND name = 'user_admin' AND model = 'res.users'
   LIMIT 1;

  IF admin_id IS NULL THEN
    SELECT ru.id INTO admin_id
      FROM res_users ru
      JOIN res_groups_users_rel gr ON gr.uid = ru.id
      JOIN ir_model_data imd
        ON imd.module = 'base' AND imd.model = 'res.groups'
       AND imd.name = 'group_system' AND imd.res_id = gr.gid
     WHERE ru.id <> 1
     ORDER BY ru.id
     LIMIT 1;
  END IF;

  UPDATE res_users
     SET login = 'user' || id || '@sandbox.local'
   WHERE id <> 1
     AND left(login, 2) <> '__'
     AND login NOT IN ('default', 'public', 'portaltemplate')
     AND (internal_ids IS NULL OR NOT (id = ANY (internal_ids)));

  IF admin_id IS NOT NULL THEN
    UPDATE res_users SET login = 'admin' WHERE id = admin_id;
  ELSE
    UPDATE res_users
       SET login = 'admin'
     WHERE id = (SELECT id FROM res_users
                  WHERE id <> 1 AND active
                    AND (internal_ids IS NULL OR NOT (id = ANY (internal_ids)))
                  ORDER BY id LIMIT 1);
  END IF;
END
$anonymize$;

-- 6b. make the administrator's e-mail agree with its login --------------------
-- The generic pass gives the admin's partner a "partner<id>@sandbox.local"
-- address. Because the login is "admin", expose "admin@sandbox.local" on the
-- user (res_users.email, 18.0) and on its partner so login and e-mail match.
DO $anonymize$
DECLARE
  admin_id integer;
BEGIN
  SELECT res_id INTO admin_id
    FROM ir_model_data
   WHERE module = 'base' AND name = 'user_admin' AND model = 'res.users'
   LIMIT 1;
  IF admin_id IS NULL THEN
    SELECT id INTO admin_id FROM res_users WHERE login = 'admin' AND id <> 1 LIMIT 1;
  END IF;
  IF admin_id IS NOT NULL THEN
    IF EXISTS (SELECT 1 FROM information_schema.columns
                WHERE table_name = 'res_users' AND column_name = 'email') THEN
      EXECUTE format('UPDATE res_users SET email = ''admin@sandbox.local'' WHERE id = %s', admin_id);
    END IF;
    EXECUTE format(
      'UPDATE res_partner SET email = ''admin@sandbox.local''
        WHERE id = (SELECT partner_id FROM res_users WHERE id = %s)', admin_id);
    IF EXISTS (SELECT 1 FROM information_schema.columns
                WHERE table_name = 'res_partner' AND column_name = 'email_normalized') THEN
      EXECUTE format(
        'UPDATE res_partner SET email_normalized = ''admin@sandbox.local''
          WHERE id = (SELECT partner_id FROM res_users WHERE id = %s)', admin_id);
    END IF;
  END IF;
END
$anonymize$;

-- 7. password reset (hash generated for the string "test", see header) --------
UPDATE res_users
   SET password = '$pbkdf2-sha512$25000$MQbg/L/3/p.zlpLSOicEYA$VSpRTyNgbEL0M/eEs3R7glnU0.2rhUdY5qmlHplkFJTecDozeLwSSjFiK8jOPF7yGo7hsLC4Aor/MG1j/NvHKQ';
