# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [basic](#basic)
    - [create `.env` file following:](#create-env-file-following)
  - [node exporter](#node-exporter)
    - [script](#script)
  - [References](#references)

---

An open-source service monitoring system and time series database, developed by SoundCloud.
Prometheus is a systems and service monitoring system.
It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

## basic

### create `.env` file following:

```env
NODE_ID=
NODE_ROLE=manager
NETWORK_MODE=overlay

PORT=9090

VERSION=latest
```

## node exporter

install **node exporter** on **client-node**:

<https://github.com/prometheus/node_exporter>

```sh
$mkdir /opt/node_exporter
$wget https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz
$tar xvfz node_exporter-1.2.2.linux-amd64.tar.gz
$cd node_exporter-*.*-amd64
$./node_exporter
```

### script

open file for create script:

```sh
$nano /etc/systemd/system/node_exporter.service
```

insert this lines:

```service
[Unit]
Description=Node Exporter

[Service]
User=root
Group=root
#EnvironmentFile=-/etc/sysconfig/node_exporter
ExecStart=/opt/node_exporter/node_exporter-1.2.2.linux-amd64/node_exporter

[Install]
WantedBy=multi-user.target
```

update service:

```sh
$systemctl daemon-reload
$systemctl start node_exporter
$systemctl enable node_exporter
$systemctl status node_exporter
```

---

## References

- <https://schroederdennis.de/allgemein/prometheus-mit-docker-installieren-und-einrichten-anleitung/>
