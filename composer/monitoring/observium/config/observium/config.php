<?php

## Check https://docs.observium.org/config_options/ for documentation of possible settings

## It's recommended that settings are edited in the web interface at /settings/ on your observium installation.
## Authentication and Database settings must be hardcoded here because they need to work before you can reach the web-based configuration interface

// Database config
// --- This MUST be configured
$config['db_host']      = getenv('OBSERVIUM_DB_HOST');
$config['db_name']      = getenv('OBSERVIUM_DB_NAME');
$config['db_user']      = getenv('OBSERVIUM_DB_USER');
$config['db_pass']      = getenv('OBSERVIUM_DB_PASS');

// Base directory
$config['install_dir'] = "/opt/observium";

// Default snmp version
$config['snmp']['version'] = "v3";
// Snmp max repetition for faster requests
#$config['snmp']['max-rep'] = TRUE;
// Default snmp community list to use when adding/discovering
// $config['snmp']['community'] = [ ];

// Authentication Model
#$config['auth_mechanism'] = "mysql";    // default, other options: ldap, http-auth, please see documentation for config help

// Enable alerter
#$config['poller-wrapper']['alerter'] = TRUE;

// Show or not disabled devices on major pages
#$config['web_show_disabled'] = FALSE;

// Set up a default alerter (email to a single address)
#$config['email']['default']        = "user@your-domain";
#$config['email']['from']           = "Observium <observium@your-domain>";

// End config.php
$config['base_url'] = getenv('OBSERVIUM_BASE_URL');
$config['enable_syslog'] = 1;

// autodiscover
$config['autodiscovery']['ip_nets']        = array("127.0.0.0/8", "192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12");
$config['autodiscovery']['snmp_scan']       = TRUE; // autodiscover hosts via SNMP scanning
