# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
      - [API Key](#api-key)
  - [References](#references)

---

## basic

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

VERSION=latest

# Mysql Parameters
MYSQL_PORT_3306_TCP_ADDR=snipe-mysql
MYSQL_PORT_3306_TCP_PORT=3306
MYSQL_ROOT_PASSWORD=YOUR_ROOT_PW
MYSQL_DATABASE=snipeit
MYSQL_USER=snipeit
MYSQL_PASSWORD=snipeit

# Email Parameters
# - the hostname/IP address of your mailserver
MAIL_PORT_587_TCP_ADDR=smtp.example.com
#the port for the mailserver (probably 587, could be another)
MAIL_PORT_587_TCP_PORT=587
# the default from address, and from name for emails
MAIL_ENV_FROM_ADDR=ex@email.com
MAIL_ENV_FROM_NAME=Your Name
# - pick 'tls' for SMTP-over-SSL, 'tcp' for unencrypted
MAIL_ENV_ENCRYPTION=tls
# SMTP username and password
MAIL_ENV_USERNAME=your_username
MAIL_ENV_PASSWORD=your_email_pw

# Snipe-IT Settings
APP_ENV=production
APP_DEBUG=false
APP_KEY={{INSERT_API_TOKEN}}
#APP_KEY=base64:uiG3aLkSmzR6jy3JcrRgWDIh6/HEpwxp+hxD3+CMS3o=
APP_URL=http://127.0.0.1:80
APP_TIMEZONE=Europe/Berlin # you should change this to your timezone
APP_LOCALE=en # you should change this for the desired language
```

#### API Key

```sh
$docker-compose up -d
$docker-compose logs -f snipeit
$docker-compose stop
```

replace `{{INSERT_API_TOKEN}}` with output from last command (from log) in your **.env** file

---

## References

- <https://snipeitapp.com/>
- <https://github.com/snipe/snipe-it>
- <https://github.com/comoser/snipe-it-docker-compose>
- <https://hub.docker.com/r/linuxserver/snipe-it>
