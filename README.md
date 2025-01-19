# Docker Collection

---

- [Docker Collection](#docker-collection)
  - [best practice start-up](#best-practice-start-up)
  - [References](#references)

---

A docker collection with composer for a fast start-up.

- Each service folder has its own **README**.

| topic                 | type               | name                                                                                     | description                                                                        |
| :-------------------- | :----------------- | :--------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------- |
| **dev**               |                    |                                                                                          |                                                                                    |
|                       | Automation Tool    | ansible                                                                                  | Configuration management and automation tool for deploying applications.           |
|                       | CMS                | cms_typo3                                                                                | Content management system for building and managing websites.                      |
|                       | IDE                | code-server                                                                              | Cloud-based development environment running Visual Studio Code.                    |
|                       | Programming Tool   | compiler-explorer                                                                        | Web-based tool for exploring compiler output for various languages.                |
|                       | CI/CD              | jenkins                                                                                  | Automation server for continuous integration and delivery.                         |
| **helper**            |                    |                                                                                          |                                                                                    |
|                       | Dashboard          | dashy                                                                                    | A customizable personal dashboard for organizing web services and links.           |
|                       | Dashboard          | heimdall                                                                                 | A web-based dashboard for organizing application links.                            |
|                       | Dashboard          | homepage                                                                                 | A static start page for personal links and dashboards.                             |
|                       | Container Manager  | portainer                                                                                | Web-based Docker container management tool.                                        |
|                       | Reverse Proxy      | traefik                                                                                  | Cloud-native reverse proxy and load balancer for Docker and Kubernetes.            |
| **monitoring**        |                    |                                                                                          |                                                                                    |
|                       | Monitoring         | beszel                                                                                   | TODO.                                                                              |
|                       | Monitoring         | checkmk                                                                                  | IT monitoring software for servers, applications, and networks.                    |
|                       | Monitoring         | librenms                                                                                 | Network monitoring system for tracking device performance and metrics.             |
|                       | Monitoring         | observium                                                                                | Auto-discovering network monitoring platform for tracking network health.          |
|                       | Monitoring         | pandorafms                                                                               | Flexible monitoring system for infrastructure and applications.                    |
|                       | Monitoring         | prometheus                                                                               | Open-source monitoring system and time-series database.                            |
|                       | Monitoring         | speedtest-tracker                                                                        | Tool for tracking internet speed test results over time.                           |
|                       | Monitoring         | uptime_kuma                                                                              | Self-hosted monitoring tool for tracking service availability.                     |
| **other**             |                    |                                                                                          |                                                                                    |
|                       | AI                 | ai-text-generation-webui                                                                 | Web interface for AI text generation models.                                       |
|                       | Security           | bloodhound                                                                               | Active Directory (AD) enumeration and attack path discovery tool.                  |
|                       | Development Tool   | dockge                                                                                   | Docker project for generic setups and experiments.                                 |
|                       | Collaboration      | focalboard                                                                               | Open-source project management software.                                           |
|                       | CMS                | ghost                                                                                    | Open-source publishing platform for blogs and content.                             |
|                       | Network Emulator   | gns3server                                                                               | Network simulation software for labs and testing.                                  |
|                       | Webcam Tool        | Linux-Fake-Background-Webcam                                                             | Simulates a virtual webcam with custom background.                                 |
|                       | Note-taking        | logseq                                                                                   | Privacy-first knowledge base and note-taking app.                                  |
|                       | Recipe Manager     | mealie                                                                                   | Self-hosted recipe management and meal-planning application.                       |
|                       | PBX                | mikopbx                                                                                  | Open-source Private Branch Exchange (PBX) system.                                  |
|                       | AI                 | ollama                                                                                   | AI-powered automation and productivity tool.                                       |
|                       | Document Manager   | paperless-ngx                                                                            | Document management system for scanning and organizing digital documents.          |
|                       | Document Manager   | papermerge                                                                               | Open-source document management system focused on OCR.                             |
|                       | Document Manager   | papermerge2                                                                              | Advanced version of Papermerge for document management.                            |
|                       | Checklist Tool     | personal-security-checklist                                                              | Personal security checklist generator and manager.                                 |
|                       | Photo Organizer    | photonix                                                                                 | Self-hosted photo management and gallery system.                                   |
|                       | Media Organizer    | tdarr_old                                                                                | Media transcoding and management tool.                                             |
|                       | Incident Response  | thehive                                                                                  | Open-source Security Incident Response Platform (SIRP).                            |
| **privacy**           |                    |                                                                                          |                                                                                    |
|                       | DNS/DDNS           | cloudflare-ddns                                                                          | Dynamic DNS tool for Cloudflare DNS management.                                    |
|                       | Tunneling          | cloudflare-tunnel                                                                        | Secure tunneling for accessing services behind NAT or firewall.                    |
|                       | VPN                | netmaker                                                                                 | Mesh VPN management and networking tool.                                           |
|                       | VPN                | openvpn                                                                                  | Open-source VPN for secure remote access.                                          |
|                       | Proxy              | snowflake-proxy                                                                          | Proxy to bypass internet censorship.                                               |
|                       | VPN                | wireguard-easy                                                                           | Easy setup and management for WireGuard VPN.                                       |
|                       | VPN                | wireguard-ui                                                                             | User interface for managing WireGuard VPN configurations.                          |
| **sec**               |                    |                                                                                          |                                                                                    |
|                       | Security           | faraday                                                                                  | Collaborative penetration testing and vulnerability management platform.           |
|                       | Malware Detection  | linux-malware-detect                                                                     | Malware detection tool for Linux systems.                                          |
|                       | Vulnerability      | nessus                                                                                   | Comprehensive vulnerability scanning tool.                                         |
|                       | Vulnerability      | nexpose                                                                                  | Security vulnerability management tool.                                            |
|                       | Tunneling          | ngrok                                                                                    | Secure tunnels for exposing local servers to the internet.                         |
|                       | Vulnerability      | openvas                                                                                  | Open-source vulnerability assessment scanner.                                      |
|                       | Security           | portspoof                                                                                | Tool for preventing port scans by simulating fake services.                        |
|                       | IDS                | suricata                                                                                 | Open-source intrusion detection and prevention system.                             |
|                       | SSH Gateway        | teleport                                                                                 | Secure access gateway for SSH and Kubernetes.                                      |
| **sec-tool-cls**      |                    |                                                                                          |                                                                                    |
|                       | Collection         | bounty-collection                                                                        | Collection of tools for bug bounty hunting and security research.                  |
|                       | Security Benchmark | docker-bench-security                                                                    | Tool for checking security best practices for Docker.                              |
|                       | Phishing           | evilginx2                                                                                | Advanced phishing attack framework.                                                |
|                       | Password Cracking  | hashcat                                                                                  | Open-source password recovery tool.                                                |
|                       | Exploitation       | metasploit                                                                               | Comprehensive penetration testing framework.                                       |
|                       | Networking         | netexec                                                                                  | Network command execution tool.                                                    |
|                       | Scanning           | nuclei                                                                                   | Fast vulnerability scanner based on templates.                                     |
|                       | Social Engineering | set                                                                                      | Social-Engineer Toolkit for penetration testing.                                   |
|                       | Exploitation       | villain                                                                                  | Multi-functional payload delivery framework.                                       |
|                       | Network Analysis   | zeek                                                                                     | Powerful network analysis framework.                                               |
| **sec-tool-services** |                    |                                                                                          |                                                                                    |
|                       | Attack Mapping     | attack-navigator                                                                         | Tool for visualizing and mapping MITRE ATT&CK techniques.                          |
|                       | Analysis           | caido                                                                                    | Analysis tool for security assessments.                                            |
|                       | Phishing           | gophish                                                                                  | Open-source phishing simulation toolkit.                                           |
|                       | Web Screenshots    | gowitness                                                                                | Tool for capturing screenshots of web services.                                    |
|                       | CTI                | opencti                                                                                  | Cyber Threat Intelligence (CTI) platform.                                          |
|                       | Reconnaissance     | spiderfoot                                                                               | Automated OSINT tool for gathering intelligence.                                   |
|                       | Forensics          | velociraptor                                                                             | Endpoint visibility and forensic tool.                                             |
|                       | Web Security       | web-check                                                                                | Automated web application security scanner.                                        |
| **siem**              |                    |                                                                                          |                                                                                    |
|                       | Threat Detection   | crowdsec                                                                                 | Collaborative cybersecurity tool for threat detection.                             |
|                       | Analytics          | grafana                                                                                  | Open-source platform for monitoring and observability dashboards.                  |
|                       | SIEM               | graylog                                                                                  | Centralized log management and analysis tool.                                      |
|                       | Time-series DB     | influxdb                                                                                 | High-performance time-series database.                                             |
|                       | Endpoint Security  | sophos                                                                                   | Advanced endpoint security and management tool.                                    |
|                       | SIEM               | splunk                                                                                   | Enterprise-level security information and event management tool.                   |
|                       | Monitoring         | telegraf                                                                                 | Metrics collection and reporting agent for InfluxDB.                               |
|                       | Incident Response  | thehive4                                                                                 | Enhanced version of TheHive for incident response.                                 |
|                       | SIEM               | wazuh                                                                                    | Open-source security monitoring and compliance tool.                               |
| **sys-admin**         |                    |                                                                                          |                                                                                    |
|                       | Boot Management    | netboot                                                                                  | PXE boot server for managing network bootable systems.                             |
|                       | IP Management      | netbox                                                                                   | IP address management and data center infrastructure modeling.                     |
|                       | Network Analysis   | ntopng                                                                                   | High-performance network traffic analysis and monitoring tool.                     |
|                       | Asset Management   | snipe-it                                                                                 | Open-source IT asset management tool.                                              |
| **sys-infra**         |                    |                                                                                          |                                                                                    |
|                       | Diagramming        | affine                                                                                   | Vector graphic design and diagramming tool.                                        |
|                       | IDE                | coder                                                                                    | Collaborative development environment.                                             |
|                       | File Management    | filebrowser                                                                              | Lightweight file management tool for web servers.                                  |
|                       | Budgeting          | firefly-iii                                                                              | Personal finance and budgeting manager.                                            |
|                       | Photo Organizer    | immich                                                                                   | Self-hosted photo and video storage and management.                                |
|                       | Budgeting          | InvoiceShelf                                                                             | Open-source invoicing software.                                                    |
|                       | Time Tracking      | kimai                                                                                    | Time-tracking software for freelancers and teams.                                  |
|                       | Cloud Storage      | nextcloud                                                                                | Open-source file sharing and collaboration platform.                               |
|                       | Cloud Storage      | nextcloud-aio                                                                            | All-in-one Dockerized Nextcloud solution.                                          |
|                       | Project Management | openproject                                                                              | Open-source project management software.                                           |
|                       | Cloud Storage      | owncloud                                                                                 | Enterprise file sharing and collaboration platform.                                |
|                       | PDF Tool           | stirling-pdf                                                                             | Tool for PDF document manipulation and editing.                                    |
|                       | File Sync          | syncthing                                                                                | Continuous file synchronization tool.                                              |
| **sys-security**      |                    |                                                                                          |                                                                                    |
|                       | Password Manager   | bitwarden                                                                                | Open-source password management solution.                                          |
|                       | Identity Platform  | goauthentik                                                                              | Open-source identity and access management system.                                 |
|                       | Password Manager   | passbolt                                                                                 | Team-based password management platform.                                           |
| **sys-tools**         |                    |                                                                                          |                                                                                    |
|                       | Battery Checker    | akkudoktor                                                                               | Tool for monitoring battery health and performance.                                |
|                       | Diagramming        | drawio                                                                                   | Web-based diagramming tool for creating flowcharts and designs.                    |
|                       | Diagramming        | excalidraw                                                                               | Open-source sketching and diagramming tool.                                        |
|                       | News Aggregator    | freshrss                                                                                 | Self-hosted RSS feed reader.                                                       |
|                       | Speed Testing      | openspeedtest                                                                            | Self-hosted internet speed testing tool.                                           |
|                       | URL Shortener      | shlink                                                                                   | Self-hosted URL shortener and analytics tool.                                      |
| **TODO**              |                    |                                                                                          |                                                                                    |
|                       | Static Site Gen    | [quartz](https://github.com/jackyzha0/quartz)                                            | static-site generator, transforms Markdown content into fully functional websites. |
|                       | Static Site Gen    | [vitepress](https://github.com/vuejs/vitepress)                                          | static site generator.                                                             |
|                       | Static Site Gen    | [pocketbase](https://github.com/pocketbase/pocketbase)                                   | Open Source realtime backend in 1 file                                             |
|                       | VPN                | [algo](https://github.com/trailofbits/algo)                                              | Set up a personal VPN in the cloud                                                 |
|                       | Email Marketing    | [listmonk](https://listmonk.app)                                                         | High-performance self-hosted newsletter and mailing list manager.                  |
|                       | Project Management | [odoo-project](https://www.odoo.com/app/project)                                         | Odoo app for managing projects and tasks.                                          |
|                       | Ticketing System   | [zammad-docker-compose](https://docs.zammad.org/en/latest/install/docker-compose.html)   | Self-hosted ticketing and customer support system.                                 |
|                       | File Management    | [pydio-cells](https://github.com/pydio/cells)                                            | Enterprise file sharing and collaboration platform.                                |
|                       | Customer Support   | [chatwoot](https://github.com/chatwoot/chatwoot)                                         | Open-source customer support and engagement platform.                              |
|                       | Monitoring         | [zabbix-docker](https://github.com/zabbix/zabbix-docker)                                 | Containerized Zabbix for IT infrastructure monitoring.                             |
|                       | Collaboration      | [mattermost](https://github.com/mattermost/mattermost)                                   | Open-source messaging and collaboration platform.                                  |
|                       | Collaboration      | [codimd](https://github.com/hackmdio/codimd)                                             | Open-source real-time collaborative markdown editor.                               |
|                       | Remote Desktop     | [rustdesk-server-oss](https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/docker) | Open-source remote desktop software with self-hosted server.                       |
|                       | Identity Platform  | [zentyal](https://zentyal.com)                                                           | Join Win-Clients to the domain and manage them transparently.                      |
|                       | Task Management    | [vikunja](https://kolaente.dev/vikunja)                                                  | Open-source project and task management tool.                                      |
|                       | Git Hosting        | [gitea](https://docs.gitea.com/installation/install-with-docker)                         | Lightweight, self-hosted Git service.                                              |
|                       | Budgeting          | [actual-budget](https://github.com/actualbudget/actual)                                  | Open-source personal budgeting software.                                           |
|                       |                    |                                                                                          |                                                                                    |

## best practice start-up

use docker-swarm to manage and start containers.

for that is in each service following defined:

```yml
services:
  ...:
    ...
    deploy:
      mode: replicated
      replicas: 1
      placement:
        max_replicas_per_node: 1
        constraints:
          # - "node.id==${NODE_ID}"
          - "node.role==${NODE_ROLE}"
      restart_policy:
        condition: on-failure
    ...
    ports:
      - target: ...
        published: ...
        mode: host
```

to start this configuration with all supportings between docker-stack and docker-composer
run it example as follow:

create alias for a `docker-swarm` command:

> _find aliases also here: [.dotfiles](https://github.com/MVladislav/.dotfiles/blob/7c928dc65c273021799314d0c373c73c88d3feac/zsh/zshrc-append#L124)_

```sh
$alias docker='DOCKER_BUILDKIT=1 docker'
$alias docker-compose='docker compose'
$alias docker-swarm-compose='docker compose --compatibility config | sed '\''s|cpus: \([0-9]\+\(\.[0-9]\+\)*\)|cpus: "\1"|'\'' | sed '\''1{/^name:/d}'\'' | sed '\''s/published: "\(.*\)"/published: \1/'\'' | docker stack deploy --resolve-image=never --with-registry-auth --detach=false --compose-file -'
$alias docker-swarm='docker compose --compatibility config | sed '\''s|cpus: \([0-9]\+\(\.[0-9]\+\)*\)|cpus: "\1"|'\'' | sed '\''1{/^name:/d}'\'' | sed '\''s/published: "\(.*\)"/published: \1/'\'' | docker stack deploy --resolve-image=always --with-registry-auth --detach=false --compose-file -'
```

and as run:

```sh
$docker-swarm-compose <STACK_NAME>
```

---

## References

- ...

---

**☕ COFFEE is a HUG in a MUG ☕**
