# Docker Collection

A curated collection of ready-to-use Docker Compose stacks for a fast and easy
start-up, designed for Docker Swarm with Traefik.

- Each service folder has its own **README** with setup instructions.
- Use [`__template/`](./__template/README.md) as the base for new services.
- Stacks run with plain `docker compose` or as Swarm services via
  `docker-swarm-compose` (see [Best Practice Start-Up](#best-practice-start-up)).

---

## Index - Current & Maintained (🟢 focused, 🆕 new)

Stack folders are grouped by **topic** (own title rows). `type` = stack kind, `ver` = image tag pinned in the compose default (see [Collection Status](#collection-status)).

| type                    | name                                                                   | ver                 | description                                                                       | last    | status        | tpl    |
| ----------------------- | ---------------------------------------------------------------------- | ------------------- | --------------------------------------------------------------------------------- | ------- | ------------- | ------ |
| **\_\_template**        |                                                                        |                     |                                                                                   |         |               |        |
| Configuration           | [README](./__template/README.md)                                       | -                   | Base configuration and templates for Docker Swarm with Traefik.                   | -       | -             | -      |
| **ai**                  |                                                                        |                     |                                                                                   |         |               |        |
| AI                      | [ollama](https://github.com/ollama/ollama)                             | rocm                | AI-powered automation and productivity tool.                                      | 2026-06 | 🟢 up-to-date | yes    |
| **helper**              |                                                                        |                     |                                                                                   |         |               |        |
| Container Management    | [dockhand](https://github.com/Finsys/dockhand)                         | v1.0.36             | Docker management you will like.                                                  | 2026-07 | 🟢 up-to-date | yes    |
| Dashboard               | [glance](https://github.com/glanceapp/glance)                          | v0.8.5              | A self-hosted dashboard that puts all your feeds in one place.                    | 2026-06 | 🟢 up-to-date | yes    |
| Proxy                   | [traefik](https://doc.traefik.io)                                      | v3.7.5              | Cloud-native reverse proxy and load balancer for Docker and Kubernetes.           | 2026-09 | 🟢 up-to-date | yes    |
| **monitoring**          |                                                                        |                     |                                                                                   |         |               |        |
| Monitoring              | [beszel](https://github.com/henrygd/beszel)                            | 0.20.0              | Lightweight server monitoring hub with historical data, docker stats, and alerts. | 2026-09 | 🟢 up-to-date | yes    |
| Monitoring Dependencies | [dependencytrack](https://github.com/DependencyTrack/dependency-track) | 5.1.1               | Intelligent Component Analysis platform, identify and reduce risk.                | 2026-08 | 🟢 up-to-date | yes    |
| Monitoring              | [patchmon](https://github.com/PatchMon/PatchMon)                       | 2.1.3               | Linux Patch Monitoring Automation Platform.                                       | 2026-09 | 🟢 up-to-date | yes    |
| Monitoring              | [speedtest-tracker](https://github.com/alexjustesen/speedtest-tracker) | 1.14.4              | Tool for tracking internet speed test results over time.                          | 2026-06 | 🟢 up-to-date | yes    |
| **other**               |                                                                        |                     |                                                                                   |         |               |        |
| Media Tracker           | [yamtrack](https://github.com/FuzzyGrim/Yamtrack)                      | 0.25.3              | Media tracker.                                                                    | 2026-07 | 🟢 up-to-date | yes    |
| **privacy**             |                                                                        |                     |                                                                                   |         |               |        |
| Proxy                   | [pangolin](https://github.com/fosrl)                                   | 1.23.0              | Secure access to your private networks, no open ports required.                   | 2026-09 | 🟢 up-to-date | custom |
| **sec-tool-services**   |                                                                        |                     |                                                                                   |         |               |        |
| Security Tools          | [so-crates](https://github.com/dougburks/so-crates)                    | 1.1                 | Security Onion deployment and management toolkit for Docker.                      | 2026-08 | 🟢 up-to-date | yes    |
| **siem**                |                                                                        |                     |                                                                                   |         |               |        |
| Digital Footprint       | [rootprint](https://github.com/rootprint/rootprint)                    | 0.4.3               | Tool for analyzing and visualizing digital footprints.                            | -       | 🆕 new        | yes    |
| **sys-admin**           |                                                                        |                     |                                                                                   |         |               |        |
| Automation              | [semaphore](https://github.com/semaphoreui/semaphore)                  | v2.18.23            | Open-source CI/CD and Ansible automation platform.                                | 2026-09 | 🟢 up-to-date | yes    |
| **sys-backup**          |                                                                        |                     |                                                                                   |         |               |        |
| Code Hosting            | [forgejo](https://codeberg.org/forgejo/forgejo)                        | 16                  | Self-hosted lightweight software forge.                                           | 2026-09 | 🟢 up-to-date | yes    |
| Email Archiving         | [open-archiver](https://github.com/LogicLabs-OU/OpenArchiver)          | v0.5.1              | Legally compliant email archiving.                                                | 2026-07 | 🟢 up-to-date | yes    |
| **sys-design**          |                                                                        |                     |                                                                                   |         |               |        |
| Diagramming             | [excalidraw](https://github.com/excalidraw/excalidraw)                 | v0.18.1             | Open-source sketching and diagramming tool.                                       | 2026-06 | 🟢 up-to-date | yes    |
| **sys-finance**         |                                                                        |                     |                                                                                   |         |               |        |
| Invoicing               | [InvoiceShelf](https://github.com/InvoiceShelf/docker)                 | 2.3.3               | Open-source invoicing software.                                                   | 2026-04 | 🟡 older      | yes    |
| **sys-infra**           |                                                                        |                     |                                                                                   |         |               |        |
| Project Management      | [odoo](https://www.odoo.com/app/project)                               | 18.0                | Odoo app for managing projects and tasks.                                         | 2026-06 | 🟢 up-to-date | yes    |
| Cloud Storage           | [owncloud](https://hub.docker.com/r/owncloud/server)                   | 10.16.3             | Enterprise file sharing and collaboration platform.                               | 2026-06 | 🟢 up-to-date | yes    |
| Project Management      | [plane](https://github.com/makeplane/plane)                            | v1.3.1              | Helps you track your issues, epics, and cycles the easiest way on the planet.     | 2026-06 | 🟢 up-to-date | yes    |
| Project Management      | [plane-com](https://github.com/makeplane/plane)                        | v3.3.0              | Commercial version of Plane for project management.                               | 2026-09 | 🟢 up-to-date | yes    |
| **sys-security**        |                                                                        |                     |                                                                                   |         |               |        |
| Identity Management     | [goauthentik](https://github.com/goauthentik/authentik)                | 2026.8.2            | Open-source identity and access management system.                                | 2026-09 | 🟢 up-to-date | yes    |
| Password Manager        | [infisical](https://github.com/Infisical/infisical)                    | v0.165.16           | Open-source secrets, certificates, and privileged access management.              | 2026-09 | 🟢 up-to-date | yes    |
| Identity Management     | [keycloak](https://github.com/keycloak/keycloak)                       | 26.7.4              | Open-source identity and access management.                                       | 2026-09 | 🟢 up-to-date | yes    |
| **sys-tools**           |                                                                        |                     |                                                                                   |         |               |        |
| News                    | [freshrss](https://github.com/FreshRSS/FreshRSS)                       | 1.29.1              | Self-hosted RSS feed reader.                                                      | 2026-06 | 🟢 up-to-date | yes    |
| Search Engine           | [searxng](https://github.com/searxng/searxng)                          | 2026.7.28-8372f5d85 | Privacy-focused metasearch engine.                                                | 2026-08 | 🟢 up-to-date | yes    |
| Tooling                 | [ittools](https://github.com/CorentinTh/it-tools)                      | 2026.1.4            | Useful tools for developer and people working in IT.                              | 2026-03 | 🟡 older      | yes    |
| Tooling                 | [omni-tools](https://github.com/iib0011/omni-tools)                    | 0.6                 | Collection of powerful web-based tools for everyday tasks.                        | 2026-03 | 🟡 older      | yes    |
| Speed Test              | [openspeedtest](https://hub.docker.com/r/openspeedtest)                | v2.0.6              | Self-hosted internet speed testing tool.                                          | 2026-01 | 🟡 older      | yes    |
| Tooling                 | [stirling-pdf](https://github.com/Stirling-Tools/Stirling-PDF)         | 2.7.2-fat           | Tool for PDF document manipulation and editing.                                   | 2026-03 | 🟡 older      | yes    |
| Resume                  | [rxresu](https://github.com/AmruthPillai/Reactive-Resume)              | v5.3.1              | A one-of-a-kind resume builder that keeps your privacy in mind.                   | 2026-09 | 🟢 up-to-date | yes    |

## Index - Bulk-only / Older / Archived (🟠 bulk-only, 🟡 older, 🔴 stale, ⚫ archived)

Stack folders are grouped by **topic** (own title rows). `type` = stack kind, `ver` = image tag pinned in the compose default (see [Collection Status](#collection-status)).

| type                    | name                                                                                                | ver                | description                                                                         | last    | status        | tpl |
| ----------------------- | --------------------------------------------------------------------------------------------------- | ------------------ | ----------------------------------------------------------------------------------- | ------- | ------------- | --- |
| **\_\_template**        |                                                                                                     |                    |                                                                                     |         |               |     |
| Configuration           | [README](./__template/README.md)                                                                    | -                  | Base configuration and templates for Docker Swarm with Traefik.                     | -       | -             | -   |
| **ai**                  |                                                                                                     |                    |                                                                                     |         |               |     |
| AI                      | [opencode](https://github.com/anomalyco/opencode)                                                   | 1.1.28             | Open source coding agent.                                                           | 2026-01 | 🟡 older      | ±   |
| **dev**                 |                                                                                                     |                    |                                                                                     |         |               |     |
| Compiler                | [compiler-explorer](https://github.com/compiler-explorer/compiler-explorer)                         | -                  | Web-based tool for exploring compiler output for various languages.                 | 2025-01 | 🔴 stale      | yes |
| CMS                     | [cms_typo3](https://get.typo3.org/#download)                                                        | 13.1.1             | Content management system for building and managing websites.                       | 2025-01 | 🔴 stale      | yes |
| IDE                     | [code-server](https://github.com/coder/code-server)                                                 | 4.105.0-ubuntu     | Cloud-based development environment running Visual Studio Code.                     | 2025-10 | 🟡 older      | yes |
| IDE                     | [coder](https://coder.com/docs/install/docker)                                                      | v2.26.2            | Collaborative development environment.                                              | 2025-10 | 🟡 older      | yes |
| **helper**              |                                                                                                     |                    |                                                                                     |         |               |     |
| Certificate Management  | [acme](https://github.com/acmesh-official/acme.sh)                                                  | 3.1.2              | Client for SSL / TLS certificate automation.                                        | 2026-03 | 🟡 older      | ±   |
| Dashboard               | [dashy](https://github.com/Lissy93/dashy)                                                           | 2.1.1              | A customizable personal dashboard for organizing web services and links.            | 2023-04 | 🔴 stale      | yes |
| Updater                 | [diun](https://github.com/crazy-max/diun)                                                           | 4.29               | Receive notifications when an image is updated on a Docker registry.                | 2026-01 | 🟡 older      | ±   |
| Dashboard               | [heimdall](https://github.com/linuxserver/Heimdall)                                                 | -                  | A web-based dashboard for organizing application links.                             | -       | 🟠 bulk-only  | no  |
| Dashboard               | [homepage](https://github.com/gethomepage/homepage)                                                 | v0.10.9            | A static start page for personal links and dashboards.                              | 2025-02 | 🔴 stale      | yes |
| Automation              | [kestra](https://github.com/kestra-io/kestra)                                                       | v0.23.5            | Event Driven Orchestration & Scheduling Platform for Mission Critical Applications. | 2025-07 | 🔴 stale      | yes |
| Automation              | [n8n](https://github.com/n8n-io/n8n)                                                                | 2.3.2              | Workflow automation platform with native AI capabilities.                           | 2026-01 | 🟡 older      | yes |
| Container Management    | [portainer](https://github.com/portainer/portainer-compose)                                         | 2.16.2-alpine      | Web-based Docker container management tool.                                         | 2022-12 | 🔴 stale      | yes |
| **monitoring**          |                                                                                                     |                    |                                                                                     |         |               |     |
| Monitoring              | [checkmate](https://github.com/bluewave-labs/Checkmate)                                             | v2.3.1             | Track and monitor server hardware, uptime, response times, and incidents.           | 2025-07 | 🔴 stale      | yes |
| Monitoring              | [checkmk](https://checkmk.com/de)                                                                   | 2.1.0              | IT monitoring software for servers, applications, and networks.                     | 2022-06 | 🔴 stale      | no  |
| Notification            | [gotify](https://github.com/gotify/server)                                                          | 2.6.1              | A simple server for sending and receiving messages.                                 | 2025-01 | 🔴 stale      | yes |
| Monitoring              | [librenms](https://github.com/librenms/librenms)                                                    | 23.2.0             | Network monitoring system for tracking device performance and metrics.              | 2023-05 | 🔴 stale      | yes |
| Monitoring              | [observium](https://observium.org)                                                                  | ce-23.9            | Auto-discovering network monitoring platform for tracking network health.           | 2024-03 | 🔴 stale      | yes |
| Monitoring              | [pandorafms](https://hub.docker.com/r/pandorafms/pandorafms-open-stack-el8)                         | -                  | Flexible monitoring system for infrastructure and applications.                     | -       | 🟠 bulk-only  | no  |
| Monitoring              | [prometheus](https://hub.docker.com/r/prom/prometheus)                                              | v2.43.0-rc.0       | Open-source monitoring system and time-series database.                             | 2023-03 | 🔴 stale      | yes |
| Monitoring              | [pulse](https://github.com/rcourtman/Pulse)                                                         | 4.30.0             | Real-time monitoring for Proxmox, Docker, and Kubernetes.                           | 2025-11 | 🟡 older      | yes |
| Monitoring              | [uptime_kuma](https://github.com/louislam/uptime-kuma)                                              | 2.0.1-slim         | Self-hosted monitoring tool for tracking service availability.                      | 2025-10 | 🟡 older      | yes |
| Monitoring              | [zabbix](https://github.com/zabbix/zabbix-docker)                                                   | 7.4.5-alpine       | Containerized Zabbix for IT infrastructure monitoring.                              | 2025-11 | 🟡 older      | yes |
| **other**               |                                                                                                     |                    |                                                                                     |         |               |     |
| Media Transcoder        | [automatic-ripping-machine](https://github.com/automatic-ripping-machine/automatic-ripping-machine) | -                  | Automatic Ripping Machine (ARM) Scripts.                                            | 2025-07 | 🔴 stale      | yes |
| Location Tracking       | [dawarich](https://github.com/Freika/dawarich)                                                      | 0.23.5             | Self-hosted alternative to Google Location History.                                 | 2025-02 | 🔴 stale      | yes |
| Project Management      | [focalboard](https://github.com/mattermost/focalboard)                                              | -                  | Open-source project management software.                                            | 2022-10 | 🔴 stale      | no  |
| Statistics              | ~~[github-stats](./composer/other/github-stats/README.md)~~                                         | -                  | GitHub statistics tool.                                                             | 2025-12 | 🟡 older      | yes |
| Signal Intelligence     | [intercept](https://github.com/smittix/intercept)                                                   | -                  | Platform that unites signal intelligence tools into a single interface.             | 2026-01 | 🟡 older      | yes |
| Video Conferencing      | [mirotalk-p2p](https://github.com/miroslavpejic85/mirotalk)                                         | -                  | Real-Time Video Conferences.                                                        | 2025-09 | 🔴 stale      | yes |
| Document Management     | [paperless-ngx](https://github.com/paperless-ngx/paperless-ngx)                                     | 2.14               | Document management system for scanning and organizing digital documents.           | 2025-02 | 🔴 stale      | yes |
| **privacy**             |                                                                                                     |                    |                                                                                     |         |               |     |
| VPN                     | [openvpn](https://openvpn.net/)                                                                     | -                  | Open-source VPN for secure remote access.                                           | 2024-03 | 🔴 stale      | ±   |
| DNS                     | [cloudflare-ddns](https://hub.docker.com/r/oznu/cloudflare-ddns)                                    | -                  | Dynamic DNS tool for Cloudflare DNS management.                                     | 2022-11 | 🔴 stale      | ±   |
| Tunneling               | [cloudflare-tunnel](https://hub.docker.com/r/cloudflare/cloudflared)                                | 2022.12.1          | Secure tunneling for accessing services behind NAT or firewall.                     | 2023-01 | 🔴 stale      | ±   |
| VPN                     | [netmaker](https://docs.netmaker.org/quick-start.html)                                              | v0.18.0            | Mesh VPN management and networking tool.                                            | 2024-10 | 🔴 stale      | yes |
| Proxy                   | [snowflake-proxy](https://gitlab.torproject.org/tpo/anti-censorship/docker-snowflake-proxy)         | -                  | Proxy to bypass internet censorship.                                                | 2022-12 | 🔴 stale      | ±   |
| SSH                     | [teleport](https://goteleport.com)                                                                  | 12                 | Secure access gateway for SSH and Kubernetes.                                       | 2025-07 | 🔴 stale      | yes |
| VPN                     | [wireguard-easy](https://github.com/wg-easy/wg-easy)                                                | 15                 | Easy setup and management for WireGuard VPN.                                        | 2025-07 | 🔴 stale      | yes |
| VPN Management          | [wireguard-ui](https://github.com/ngoduykhanh/wireguard-ui)                                         | -                  | User interface for managing WireGuard VPN configurations.                           | 2024-10 | 🔴 stale      | yes |
| **sec**                 |                                                                                                     |                    |                                                                                     |         |               |     |
| Tunneling               | [ngrok](https://ngrok.com)                                                                          | -                  | Secure tunnels for exposing local servers to the internet.                          | 2022-10 | 🔴 stale      | no  |
| Malware Detection       | [linux-malware-detect](https://github.com/rfxn/linux-malware-detect)                                | -                  | Malware detection tool for Linux systems.                                           | 2022-11 | 🔴 stale      | ±   |
| Vulnerability Scanner   | [nexpose](https://docs.rapid7.com/nexpose/install)                                                  | -                  | Security vulnerability management tool.                                             | 2022-11 | 🔴 stale      | yes |
| Network Security        | [portspoof](https://github.com/strandjs/IntroLabs)                                                  | -                  | Tool for preventing port scans by simulating fake services.                         | 2022-04 | 🔴 stale      | no  |
| IDS/IPS                 | [suricata](https://github.com/OISF/suricata)                                                        | 7.0.0-beta1        | Open-source intrusion detection and prevention system.                              | 2022-11 | 🔴 stale      | ±   |
| Penetration Testing     | [faraday](https://github.com/infobyte/faraday)                                                      | 5.1.1              | Collaborative penetration testing and vulnerability management platform.            | 2024-05 | 🔴 stale      | yes |
| Vulnerability Scanner   | [nessus](https://hub.docker.com/r/tenableofficial/nessus)                                           | 10.7.1-ubuntu      | Comprehensive vulnerability scanning tool.                                          | 2024-03 | 🔴 stale      | yes |
| Vulnerability Scanner   | [openvas](https://hub.docker.com/r/greenbone/openvas-scanner)                                       | stable             | Open-source vulnerability assessment scanner.                                       | 2025-06 | 🔴 stale      | yes |
| **sec-tool-cls**        |                                                                                                     |                    |                                                                                     |         |               |     |
| Security Tools          | [bounty-collection](https://github.com/MVladislav/vm-docker-collection)                             | -                  | Collection of tools for bug bounty hunting and security research.                   | 2025-04 | 🔴 stale      | ±   |
| Password Cracking       | [hashcat](https://github.com/hashcat/hashcat)                                                       | -                  | Open-source password recovery tool.                                                 | -       | 🟠 bulk-only  | ±   |
| Exploitation            | [villain](https://github.com/t3l3machus/villain)                                                    | -                  | Multi-functional payload delivery framework.                                        | 2022-12 | 🔴 stale      | ±   |
| Security Benchmark      | [docker-bench-security](https://github.com/docker/docker-bench-security)                            | -                  | Tool for checking security best practices for Docker.                               | 2022-12 | 🔴 stale      | ±   |
| Phishing                | [evilginx2](https://github.com/kgretzky/evilginx2)                                                  | -                  | Advanced phishing attack framework.                                                 | 2024-05 | 🔴 stale      | yes |
| Exploitation            | [metasploit](https://github.com/rapid7/metasploit-framework)                                        | -                  | Comprehensive penetration testing framework.                                        | 2024-05 | 🔴 stale      | ±   |
| Exploitation            | [netexec](https://github.com/Pennyw0rth/NetExec)                                                    | -                  | Network command execution tool.                                                     | 2024-05 | 🔴 stale      | ±   |
| Vulnerability Scanner   | [nuclei](https://github.com/projectdiscovery/nuclei)                                                | -                  | Fast vulnerability scanner based on templates.                                      | 2022-11 | 🔴 stale      | ±   |
| Social Engineering      | [set](https://github.com/trustedsec/social-engineer-toolkit)                                        | -                  | Social-Engineer Toolkit for penetration testing.                                    | 2022-12 | 🔴 stale      | no  |
| Network Analysis        | [zeek](https://github.com/zeek/zeek)                                                                | 7.1                | Powerful network analysis framework.                                                | 2025-01 | 🔴 stale      | ±   |
| **sec-tool-services**   |                                                                                                     |                    |                                                                                     |         |               |     |
| Forensics               | [velociraptor](https://github.com/Velocidex/velociraptor)                                           | -                  | Endpoint visibility and forensic tool.                                              | 2025-01 | 🔴 stale      | yes |
| Attack Mapping          | [attack-navigator](https://github.com/mitre-attack/attack-navigator)                                | -                  | Tool for visualizing and mapping MITRE ATT&CK techniques.                           | 2024-11 | 🔴 stale      | ±   |
| Vulnerability Scanner   | [caido](https://github.com/caido/caido)                                                             | -                  | Analysis tool for security assessments.                                             | 2025-01 | 🔴 stale      | yes |
| Phishing                | [gophish](https://github.com/gophish/gophish)                                                       | 0.12.1             | Open-source phishing simulation toolkit.                                            | 2023-05 | 🔴 stale      | yes |
| Security Assetmanagment | [gowitness](https://github.com/sensepost/gowitness)                                                 | -                  | Tool for capturing screenshots of web services.                                     | 2024-11 | 🔴 stale      | yes |
| Security Assetmanagment | [opencti](https://github.com/OpenCTI-Platform/docker)                                               | 6.4.1              | Cyber Threat Intelligence (CTI) platform.                                           | 2024-11 | 🔴 stale      | yes |
| Reconnaissance          | [spiderfoot](https://github.com/smicallef/spiderfoot)                                               | -                  | Automated OSINT tool for gathering intelligence.                                    | 2022-12 | 🔴 stale      | yes |
| Security Assetmanagment | [web-check](https://github.com/Lissy93/web-check)                                                   | -                  | Automated web application security scanner.                                         | 2024-11 | 🔴 stale      | yes |
| **siem**                |                                                                                                     |                    |                                                                                     |         |               |     |
| SIEM/Observability      | [crowdsec](https://crowdsec.net)                                                                    | -                  | Collaborative cybersecurity tool for threat detection.                              | 2024-09 | 🔴 stale      | no  |
| SIEM/Observability      | [grafana](https://grafana.com)                                                                      | 11.5.2             | Open-source platform for monitoring and observability dashboards.                   | 2025-01 | 🔴 stale      | yes |
| SIEM/Observability      | [graylog](https://github.com/Graylog2/graylog-docker)                                               | 6.2                | Centralized log management and analysis tool.                                       | 2025-06 | 🔴 stale      | yes |
| Time-Series DB          | [influxdb](https://hub.docker.com/_/influxdb)                                                       | 2.7.11-alpine      | High-performance time-series database.                                              | 2025-01 | 🔴 stale      | yes |
| Endpoint Security       | [sophos](https://github.com/sophos/Sophos-Central-SIEM-Integration)                                 | 2022-10-17         | Advanced endpoint security and management tool.                                     | 2022-11 | 🔴 stale      | no  |
| SIEM/Observability      | [splunk](https://hub.docker.com/r/splunk/splunk)                                                    | 8.2                | Enterprise-level security information and event management tool.                    | 2023-03 | 🔴 stale      | yes |
| Metrics Agent           | [telegraf](https://github.com/influxdata/telegraf)                                                  | -                  | Metrics collection and reporting agent for InfluxDB.                                | 2022-02 | 🔴 stale      | no  |
| Incident Response       | [thehive4](https://github.com/TheHive-Project/Docker-Templates)                                     | -                  | Enhanced version of TheHive for incident response.                                  | 2024-10 | 🔴 stale      | no  |
| SIEM/Observability      | [wazuh](https://github.com/wazuh/wazuh-docker)                                                      | 4.12.0             | Open-source security monitoring and compliance tool.                                | 2025-12 | 🟡 older      | yes |
| **smart**               |                                                                                                     |                    |                                                                                     |         |               |     |
| Energy Management       | [akkudoktor](https://github.com/Akkudoktor-EOS/EOS)                                                 | main               | Tool for monitoring battery health and performance.                                 | 2026-01 | 🟡 older      | yes |
| Energy Management       | [evcc](https://github.com/evcc-io/evcc)                                                             | 0.300.2            | EV Charge Controller and home energy management system.                             | 2026-01 | 🟡 older      | yes |
| Household Management    | [grocy](https://github.com/grocy/grocy)                                                             | 4.5.0              | Groceries & household management solution for your home.                            | 2026-01 | 🟡 older      | yes |
| Recipe Management       | [mealie](https://github.com/mealie-recipes/mealie)                                                  | v1.11.0            | Self-hosted recipe management and meal-planning application.                        | 2026-01 | 🟡 older      | yes |
| **sys-admin**           |                                                                                                     |                    |                                                                                     |         |               |     |
| Network Boot            | [netboot](https://github.com/netbootxyz/docker-netbootxyz)                                          | 0.7.3-nbxyz3       | PXE boot server for managing network bootable systems.                              | 2025-01 | 🔴 stale      | yes |
| IPAM                    | [netbox](https://github.com/netbox-community/netbox-docker)                                         | v4.7.1             | IP address management and data center infrastructure modeling.                      | 2026-09 | 🟢 up-to-date | yes |
| Asset Management        | [snipe-it](https://github.com/snipe/snipe-it)                                                       | v6.3.4             | Open-source IT asset management tool.                                               | 2024-05 | 🔴 stale      | yes |
| **sys-backup**          |                                                                                                     |                    |                                                                                     |         |               |     |
| File Synchronization    | [syncthing](https://github.com/syncthing/syncthing)                                                 | 1.27               | Continuous file synchronization tool.                                               | 2026-01 | 🟡 older      | yes |
| Backup Automation       | [zerobyte](https://github.com/nicotsx/zerobyte)                                                     | v0.21              | Backup automation.                                                                  | 2026-09 | 🟢 up-to-date | yes |
| **sys-design**          |                                                                                                     |                    |                                                                                     |         |               |     |
| Diagramming             | [drawio](https://github.com/jgraph/docker-drawio)                                                   | 29.7.9             | Web-based diagramming tool for creating flowcharts and designs.                     | 2026-04 | 🟡 older      | yes |
| Diagramming             | [penpot](https://help.penpot.app/technical-guide/getting-started/#install-with-docker)              | 2.12.1             | Design & prototype platform that is deployment agnostic.                            | 2026-01 | 🟡 older      | yes |
| **sys-finance**         |                                                                                                     |                    |                                                                                     |         |               |     |
| Budgeting               | [actualbudget](https://github.com/actualbudget/actual)                                              | sha-42c184a-alpine | Open-source personal budgeting software.                                            | 2025-11 | 🟡 older      | yes |
| ERP                     | [erpnext](https://github.com/frappe/erpnext)                                                        | v15.70.0           | Free and Open Source Enterprise Resource Planning (ERP).                            | 2025-09 | 🟡 older      | yes |
| Budgeting               | [firefly-iii](https://github.com/firefly-iii/docker)                                                | version-6.1.25     | Personal finance and budgeting manager.                                             | 2025-09 | 🟡 older      | yes |
| **sys-infra**           |                                                                                                     |                    |                                                                                     |         |               |     |
| Email Marketing         | [listmonk](https://listmonk.app)                                                                    | v4.1.0             | High-performance self-hosted newsletter and mailing list manager.                   | 2025-04 | 🔴 stale      | yes |
| Cloud Storage           | [nextcloud-aio](https://github.com/nextcloud/all-in-one)                                            | 20250325_084656    | All-in-one Dockerized Nextcloud solution.                                           | 2026-03 | 🟡 older      | ±   |
| Note-taking             | [affine](https://github.com/toeverything/AFFiNE)                                                    | stable-129ccea     | Vector graphic design and diagramming tool.                                         | 2024-11 | 🔴 stale      | yes |
| Appointment Scheduler   | [calcom](https://github.com/calcom/cal.com)                                                         | v5.4.4             | Scheduling infrastructure for absolutely everyone.                                  | 2025-06 | 🔴 stale      | yes |
| Documentation           | [docmost](https://github.com/docmost/docmost)                                                       | 0.20.1             | Collaborative wiki and documentation software.                                      | 2025-04 | 🔴 stale      | yes |
| Appointment Scheduler   | [easyappointments](https://github.com/alextselegidis/easyappointments)                              | 1.5.1              | Self Hosted Appointment Scheduler.                                                  | 2025-06 | 🔴 stale      | yes |
| CMS                     | [ghost](https://hub.docker.com/_/ghost)                                                             | 5-alpine           | Open-source publishing platform for blogs and content.                              | 2025-04 | 🔴 stale      | yes |
| Photo Organizer         | [immich](https://github.com/immich-app/immich)                                                      | v1.120.1           | Self-hosted photo and video storage and management.                                 | 2024-11 | 🔴 stale      | yes |
| Time Tracking           | [kimai](https://github.com/kimai/kimai)                                                             | apache-2.33.0      | Time-tracking software for freelancers and teams.                                   | 2025-06 | 🔴 stale      | yes |
| Cloud Storage           | [nextcloud](https://github.com/nextcloud/docker)                                                    | 27.1.3-apache      | Open-source file sharing and collaboration platform.                                | 2023-10 | 🔴 stale      | yes |
| Project Management      | [openproject](https://github.com/opf/openproject-deploy)                                            | 15-slim            | Open-source project management software.                                            | 2025-01 | 🔴 stale      | yes |
| **sys-security**        |                                                                                                     |                    |                                                                                     |         |               |     |
| Password Manager        | [bitwarden](https://github.com/bitwarden/server)                                                    | beta               | Open-source password management solution.                                           | 2024-04 | 🔴 stale      | yes |
| Password Manager        | [passbolt](https://hub.docker.com/r/passbolt/passbolt)                                              | 3.9.0-2-ce         | Team-based password management platform.                                            | 2024-04 | 🔴 stale      | yes |
| **sys-tools**           |                                                                                                     |                    |                                                                                     |         |               |     |
| Shortener               | [shlink](https://hub.docker.com/r/shlinkio/shlink)                                                  | -                  | Self-hosted URL shortener and analytics tool.                                       | 2022-05 | 🔴 stale      | no  |

### POSSIBLE LATER

Backlog of interesting stacks that are candidates but **not (yet)** added as a full collection folder. Same columns as the index - to adopt one, cut/paste its row into the right **topic** group above.

| type                 | name                                                                                   | ver | description                                                                              | last | status | tpl |
| -------------------- | -------------------------------------------------------------------------------------- | --- | ---------------------------------------------------------------------------------------- | ---- | ------ | --- |
| AI                   | collection                                                                             | -   | Collection of AI tools.                                                                  | -    | -      | -   |
| Monitoring           | [dmarcguardhq](https://github.com/dmarcguardhq/dmarcguard)                             | -   | DMARC report parser.                                                                     | -    | -      | -   |
| Security Benchmark   | [mondoo](https://github.com/mondoo/mondoo)                                             | -   | Universal security scanning tool.                                                        | -    | -      | -   |
| Remote Desktop       | [rustdesk](https://github.com/rustdesk/rustdesk-server)                                | -   | Open-source remote desktop software with self-hosted server.                             | -    | -      | -   |
| Wealth Management    | [ghostfolio](https://github.com/ghostfolio/ghostfolio)                                 | -   | Open Source Wealth Management Software.                                                  | -    | -      | -   |
| Tooling              | [project-nomad](https://github.com/crosstalk-solutions/project-nomad)                  | -   | Offline survival computer packed with critical tools, knowledge, and AI.                 | -    | -      | -   |
| \*Container Manager  | [komodo](https://github.com/moghtech/komodo)                                           | -   | A tool to build and deploy software on many servers.                                     | -    | -      | -   |
| \*URL Shortener      | [kutt](https://github.com/thedevs-network/kutt)                                        | -   | Modern URL shortener with support for custom domains.                                    | -    | -      | -   |
| Static Site Gen      | [quartz](https://github.com/jackyzha0/quartz)                                          | -   | static-site generator, transforms Markdown content into fully functional websites.       | -    | -      | -   |
| Static Site Gen      | [vitepress](https://github.com/vuejs/vitepress)                                        | -   | static site generator.                                                                   | -    | -      | -   |
| Static Site Gen      | [pocketbase](https://github.com/pocketbase/pocketbase)                                 | -   | Open Source realtime backend in 1 file.                                                  | -    | -      | -   |
| \*VPN                | [algo](https://github.com/trailofbits/algo)                                            | -   | Set up a personal VPN in the cloud.                                                      | -    | -      | -   |
| VPN                  | [WGDashboard](https://github.com/donaldzou/WGDashboard)                                | -   | Simple dashboard for WireGuard VPN.                                                      | -    | -      | -   |
| \*Proxy              | [zoraxy](https://github.com/tobychui/zoraxy)                                           | -   | HTTP reverse proxy and forwarding tool. Now written in Go!                               | -    | -      | -   |
| HRM                  | [orangehrm](https://github.com/orangehrm/orangehrm)                                    | -   | Open-source HR management software.                                                      | -    | -      | -   |
| Ticketing System     | [zammad-docker-compose](https://docs.zammad.org/en/latest/install/docker-compose.html) | -   | Self-hosted ticketing and customer support system.                                       | -    | -      | -   |
| \*File Management    | [pydio-cells](https://github.com/pydio/cells)                                          | -   | Enterprise file sharing and collaboration platform.                                      | -    | -      | -   |
| \*File Management    | [Sync-in](https://github.com/Sync-in/server)                                           | -   | Sovereign platform for file storage, sharing, synchronization, and collaboration.        | -    | -      | -   |
| Customer Support     | [chatwoot](https://github.com/chatwoot/chatwoot)                                       | -   | Open-source customer support and engagement platform.                                    | -    | -      | -   |
| Monitoring           | [OpenTelemetry](https://opentelemetry.io/docs/demo/docker-deployment)                  | -   | High-quality, ubiquitous, and portable telemetry to enable effective observability.      | -    | -      | -   |
| Monitoring           | [sensu-go](https://github.com/sensu/sensu-go)                                          | -   | Simple. Scalable. Multi-cloud monitoring.                                                | -    | -      | -   |
| Monitoring           | [unpoller](https://github.com/unpoller/unpoller)                                       | -   | Collect UniFi Data - Export to InfluxDB or Prometheus.                                   | -    | -      | -   |
| Collaboration        | [mattermost](https://github.com/mattermost/mattermost)                                 | -   | Open-source messaging and collaboration platform.                                        | -    | -      | -   |
| Collaboration        | [codimd](https://github.com/hackmdio/codimd)                                           | -   | Open-source real-time collaborative markdown editor.                                     | -    | -      | -   |
| Identity Platform    | [zentyal](https://zentyal.com)                                                         | -   | Join Win-Clients to the domain and manage them transparently.                            | -    | -      | -   |
| Task Management      | [vikunja](https://kolaente.dev/vikunja)                                                | -   | Open-source project and task management tool.                                            | -    | -      | -   |
| Git Hosting          | [gitea](https://docs.gitea.com/installation/install-with-docker)                       | -   | Lightweight, self-hosted Git service.                                                    | -    | -      | -   |
| Reporting            | [BugZilla](https://github.com/bugzilla/bugzilla)                                       | -   | The software solution designed to drive software development.                            | -    | -      | -   |
| Testing              | [netpicker](https://github.com/netpicker/netpicker)                                    | -   | Test your network compliance, design and security.                                       | -    | -      | -   |
| \*Wiki               | [wiki.js](https://github.com/requarks/wiki)                                            | -   | A modern and powerful wiki app built on Node.js.                                         | -    | -      | -   |
| \*Wiki               | [outline](https://github.com/outline/outline)                                          | -   | The fastest knowledge base for growing teams.                                            | -    | -      | -   |
| Wiki                 | [BookStack](https://github.com/BookStackApp/BookStack)                                 | -   | A platform to create documentation/wiki content.                                         | -    | -      | -   |
| CRM                  | [twenty](https://github.com/twentyhq/twenty)                                           | -   | Building a modern alternative to Salesforce, powered by the community.                   | -    | -      | -   |
| Monitoring           | [NetAlertX](https://github.com/jokob-sk/NetAlertX)                                     | -   | Network intruder and presence detector.                                                  | -    | -      | -   |
| Webhook              | [Operational](https://github.com/operational-co/operational.co)                        | -   | Track important events and receive push notifications.                                   | -    | -      | -   |
| HRM                  | [urlaubsverwaltung](https://github.com/urlaubsverwaltung/urlaubsverwaltung)            | -   | Open-source vacation and absence management.                                             | -    | -      | -   |
|                      |                                                                                        | -   |                                                                                          | -    | -      | -   |
| Social Marketing     | [postiz](https://github.com/gitroomhq/postiz-docker-compose)                           | -   | The ultimate social media scheduling tool, with a bunch of AI.                           | -    | -      | -   |
|                      |                                                                                        | -   |                                                                                          | -    | -      | -   |
|                      | [linkarr](https://github.com/itsmejoeeey/linkarr)                                      | -   |                                                                                          | -    | -      | -   |
|                      | [cronmaster](https://github.com/fccview/cronmaster)                                    | -   |                                                                                          | -    | -      | -   |
|                      | [HarborGuard](https://github.com/HarborGuard/HarborGuard)                              | -   |                                                                                          | -    | -      | -   |
| Forum                | [discourse](https://github.com/discourse/discourse)                                    | -   | Open-source discussion platform.                                                         | -    | -      | -   |
| Media Server         | [coturn](https://github.com/coturn/coturn)                                             | -   | coturn TURN server project.                                                              | -    | -      | -   |
|                      |                                                                                        | -   |                                                                                          | -    | -      | -   |
| AI                   | [Bytebot](https://github.com/bytebot-ai/bytebot)                                       | -   | AI-powered browser automation.                                                           | -    | -      | -   |
| AI                   | [airi](https://github.com/moeru-ai/airi)                                               | -   |                                                                                          | -    | -      | -   |
| AI                   | [zeroclaw](https://github.com/zeroclaw-labs/zeroclaw)                                  | -   |                                                                                          | -    | -      | -   |
| AI                   | [nanoclaw](https://github.com/nanocoai/nanoclaw)                                       | -   |                                                                                          | -    | -      | -   |
|                      |                                                                                        | -   |                                                                                          | -    | -      | -   |
| Stream               | [Apollo](https://github.com/ClassicOldSong/Apollo)                                     | -   |                                                                                          | -    | -      | -   |
|                      |                                                                                        | -   |                                                                                          | -    | -      | -   |
| \*Analytics          | [Rybbit](https://github.com/rybbit-io/rybbit)                                          | -   |                                                                                          | -    | -      | -   |
| Email Marketing      | [BillionMail](https://github.com/aaPanel/BillionMail)                                  | -   |                                                                                          | -    | -      | -   |
|                      | [HeadlessX](https://github.com/saifyxpro/HeadlessX)                                    | -   |                                                                                          | -    | -      | -   |
|                      | [HomeHub](https://github.com/surajverma/homehub)                                       | -   |                                                                                          | -    | -      | -   |
|                      | [Glass-Keep](https://github.com/nikunjsingh93/react-glass-keep)                        | -   |                                                                                          | -    | -      | -   |
| Container Management | [Dockpeek](https://github.com/dockpeek/dockpeek)                                       | -   | Web UI for managing Docker containers.                                                   | -    | -      | -   |
| Terminal             | [Termix](https://github.com/LukeGus/Termix)                                            | -   | Terminal emulator.                                                                       | -    | -      | -   |
|                      | [SurfSense](https://github.com/MODSetter/SurfSense)                                    | -   |                                                                                          | -    | -      | -   |
| Monitoring           | [komari](https://github.com/komari-monitor/komari)                                     | -   |                                                                                          | -    | -      | -   |
|                      | [PigeonPod](https://github.com/aizhimou/pigeon-pod)                                    | -   |                                                                                          | -    | -      | -   |
| \*Tooling            | [BentoPDF](https://github.com/alam00000/bentopdf)                                      | -   |                                                                                          | -    | -      | -   |
|                      | [Dispatcharr](https://github.com/Dispatcharr/Dispatcharr)                              | -   |                                                                                          | -    | -      | -   |
|                      | [Foxel](https://github.com/DrizzleTime/Foxel)                                          | -   |                                                                                          | -    | -      | -   |
| URL Shortener        | [chhoto-url](https://github.com/SinTan1729/chhoto-url)                                 | -   | Self-hosted URL shortener.                                                               | -    | -      | -   |
|                      | [CommonForms](https://github.com/jbarrow/commonforms)                                  | -   |                                                                                          | -    | -      | -   |
|                      |                                                                                        | -   |                                                                                          | -    | -      | -   |
|                      | [ElevenLabs UI](https://github.com/elevenlabs/ui)                                      | -   |                                                                                          | -    | -      | -   |
| AI                   | [Dexter](https://github.com/virattt/dexter)                                            | -   | Open-source AI agents for accounting.                                                    | -    | -      | -   |
|                      | [Firm](https://github.com/42futures/firm)                                              | -   |                                                                                          | -    | -      | -   |
| AI                   | [FullstackAgent](https://github.com/FullstackAgent/FullstackAgent)                     | -   |                                                                                          | -    | -      | -   |
| AI                   | [Open Computer Use](https://github.com/LLmHub-dev/open-computer-use)                   | -   |                                                                                          | -    | -      | -   |
| AI                   | [TinyRecursiveModels](https://github.com/SamsungSAILMontreal/TinyRecursiveModels)      | -   |                                                                                          | -    | -      | -   |
|                      | [Neura Hustle Tracker](https://github.com/adolfousier/neura-hustle-tracker)            | -   |                                                                                          | -    | -      | -   |
|                      | [Puffin](https://github.com/KangLiao929/Puffin)                                        | -   |                                                                                          | -    | -      | -   |
|                      | [Cronboard](https://github.com/antoniorodr/Cronboard)                                  | -   |                                                                                          | -    | -      | -   |
|                      | [Pyversity](https://github.com/Pringled/pyversity)                                     | -   |                                                                                          | -    | -      | -   |
|                      | [Blaze](https://github.com/wizenheimer/blaze)                                          | -   |                                                                                          | -    | -      | -   |
|                      | [Keyer](https://github.com/mafik/keyer)                                                | -   |                                                                                          | -    | -      | -   |
|                      | [Everywhere](https://github.com/DearVa/Everywhere)                                     | -   |                                                                                          | -    | -      | -   |
|                      | [Mina Rich Editor](https://github.com/Mina-Massoud/Mina-Rich-Editor)                   | -   |                                                                                          | -    | -      | -   |
| AI                   | [Stable Video Infinity](https://github.com/vita-epfl/Stable-Video-Infinity)            | -   |                                                                                          | -    | -      | -   |
| AI                   | [Sora MCP Server](https://github.com/Doriandarko/sora-mcp)                             | -   |                                                                                          | -    | -      | -   |
|                      |                                                                                        | -   |                                                                                          | -    | -      | -   |
|                      | [ThinkDashboard](https://github.com/MatiasDesuu/ThinkDashboard)                        | -   |                                                                                          | -    | -      | -   |
|                      | [mainline-nextjs-template](https://github.com/shadcnblocks/mainline-nextjs-template)   | -   |                                                                                          | -    | -      | -   |
|                      | [portfolio](https://github.com/NotStark/portfolio)                                     | -   |                                                                                          | -    | -      | -   |
|                      | [WithAnyone](https://github.com/Doby-Xu/WithAnyone)                                    | -   |                                                                                          | -    | -      | -   |
|                      |                                                                                        | -   |                                                                                          | -    | -      | -   |
| Monitoring           | [arpwatch](https://github.com/brandonleegit/arpwatch)                                  | -   | Monitors ARP activity on the network.                                                    | -    | -      | -   |
| Monitoring           | [SmokePing](https://github.com/oetiker/SmokePing)                                      | -   | Network latency monitoring and graphing.                                                 | -    | -      | -   |
| Logging              | [logforge](https://github.com/log-forge/logforge)                                      | -   |                                                                                          | -    | -      | -   |
| Photo Organizer      | [photonix](https://github.com/photonixapp/photonix)                                    | -   | Self-hosted photo management and gallery system.                                         | -    | -      | -   |
| Transcoder           | [tdarr_old](https://github.com/haveagitgat/tdarr)                                      | -   | Media transcoding and management tool.                                                   | -    | -      | -   |
|                      |                                                                                        | -   |                                                                                          | -    | -      | -   |
| \*Monitoring         | [sentry](https://github.com/getsentry/self-hosted)                                     | -   | https://develop.sentry.dev/self-hosted/                                                  | -    | -      | -   |
| Database             | [ClickHouse](https://github.com/ClickHouse/ClickStack.git)                             | -   | https://clickhouse.com/docs/use-cases/observability/clickstack/deployment/docker-compose | -    | -      | -   |

### Backlog / not added

| topic | type                      | name                                                                                      | description                                                                                      |
| ----- | ------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
|       | Container Manager         | ~~[dockge](https://github.com/louislam/dockge)~~                                          | Docker project for generic setups and experiments.                                               |
|       | File Management           | ~~[filebrowser](https://github.com/filebrowser/filebrowser)~~                             | Upstream archived; consider [Filux](https://forge.routemehome.org/brian/Filux) as a replacement. |
|       |                           |                                                                                           |                                                                                                  |
|       | AI                        | ~~[ai-text-generation-webui](https://github.com/oobabooga/text-generation-webui)~~        | Web interface for AI text generation models.                                                     |
|       | AI                        | ~~[claude-code](https://github.com/anthropics/claude-code)~~                              | Agentic coding tool that lives in your terminal.                                                 |
|       | AI                        | ~~[meetily](https://github.com/Zackriya-Solutions/meetily)~~                              | AI meeting assistant.                                                                            |
|       | CI/CD                     | ~~[jenkins](https://www.jenkins.io/doc/book/installing/docker)~~                          | Automation server for continuous integration and delivery.                                       |
|       | OS                        | ~~[win](https://github.com/dockur/windows)~~                                              | Windows inside a Docker container.                                                               |
|       | Monitoring                | ~~[ntopng](https://github.com/ntop/docker-ntop)~~                                         | High-performance network traffic analysis and monitoring tool.                                   |
|       | Network Emulator          | ~~[gns3server](https://github.com/GNS3/gns3-server)~~                                     | Network simulation software for labs and testing.                                                |
|       | Chat Server               | ~~[matrix](https://matrix.org)~~                                                          | Open-source matrix messaging server.                                                             |
|       | PBX                       | ~~[mikopbx](https://github.com/mikopbx/Core)~~                                            | Open-source Private Branch Exchange (PBX) system.                                                |
|       | API Testing               | ~~[requestly](https://github.com/requestly/requestly/)~~                                  | The privacy-first Postman alternative.                                                           |
|       | SMS Gateway               | ~~[smfc](https://github.com/EdJoPaTo/smfc)~~                                              | SMS gateway service.                                                                             |
|       | Appointment Scheduler     | ~~[thunderbird-appointment](https://github.com/thunderbird/appointment)~~                 | Make appointments as easy as it gets.                                                            |
|       | VPN                       | ~~[netbird](https://github.com/netbirdio/netbird)~~                                       | Secure WireGuard-based overlay network with SSO, MFA and granular access controls.               |
|       | Vulnerability Scanner     | ~~[bloodhound](https://github.com/SpecterOps/BloodHound)~~                                | Active Directory (AD) enumeration and attack path discovery tool.                                |
|       | Vulnerability Scanner     | ~~[ecsypno](https://github.com/scnr/installer)~~                                          | The all-seeing web application security scanner.                                                 |
|       | Security Assetmanagment   | ~~[personal-security-checklist](https://github.com/Lissy93/personal-security-checklist)~~ | Personal security checklist generator and manager.                                               |
|       | Incident Response         | ~~[thehive](https://github.com/StrangeBeeCorp/docker)~~                                   | Open-source Security Incident Response Platform (SIRP).                                          |
|       | Budgeting                 | ~~[openbudgeteer](https://github.com/TheAxelander/OpenBudgeteer)~~                        |                                                                                                  |
|       | Payment                   | ~~[payme](https://github.com/cachebag/payme)~~                                            |                                                                                                  |
|       | Budgeting                 | ~~[saldoify](https://github.com/Raihan-Software/saldoify)~~                               |                                                                                                  |
|       | Project Management        | ~~[appflowy](https://github.com/AppFlowy-IO/AppFlowy-Cloud)~~                             | The leading open source Notion alternative.                                                      |
|       | Office Suite              | ~~[euro-office](https://github.com/Euro-Office/DocumentServer)~~                          | Office suite for document management.                                                            |
|       | Office Suite              | ~~[onlyoffice](https://github.com/ONLYOFFICE/Docker-CommunityServer)~~                    | Open-source office suite for document editing and collaboration.                                 |
|       | Virtualization Management | ~~proxmox-pdm~~                                                                           | Proxmox PDM management interface.                                                                |

### Quick PenTest

| &nbsp;                                                            | &nbsp;             | &nbsp;                                                                      |
| ----------------------------------------------------------------- | ------------------ | --------------------------------------------------------------------------- |
| [README](./composer/helper/traefik/README.md)                     | Proxy              | [traefik](https://doc.traefik.io)                                           |
| [README](./composer/dev/compiler-explorer/README.md)              | Programming Tool   | [compiler-explorer](https://github.com/compiler-explorer/compiler-explorer) |
| [README](./composer/ai/ollama/README.md)                          | AI                 | [ollama](https://github.com/ollama/ollama)                                  |
| [README](./composer/privacy/pangolin/README.md)                   | Proxy              | [pangolin](https://github.com/fosrl)                                        |
| [README](./composer/sec/ngrok/README.md)                          | Tunneling          | [ngrok](https://ngrok.com)                                                  |
| [README](./composer/sec-tool-cls/set/README.md)                   | Social Engineering | [set](https://github.com/trustedsec/social-engineer-toolkit)                |
| [README](./composer/sec-tool-services/attack-navigator/README.md) | Attack Mapping     | [attack-navigator](https://github.com/mitre-attack/attack-navigator)        |
| [README](./composer/sec-tool-services/caido/README.md)            | Analysis           | [caido](https://github.com/caido/caido)                                     |
| [README](./composer/monitoring/dependencytrack/README.md)         | Attack Mapping     | [dependencytrack](https://github.com/DependencyTrack/dependency-track)      |
| [README](./composer/sec-tool-services/gophish/README.md)          | Phishing           | [gophish](https://github.com/gophish/gophish)                               |
| [README](./composer/sec-tool-services/gowitness/README.md)        | Web Screenshots    | [gowitness](https://github.com/sensepost/gowitness)                         |
| [README](./composer/sec-tool-services/opencti/README.md)          | CTI                | [opencti](https://github.com/OpenCTI-Platform/docker)                       |
| [README](./composer/sec-tool-services/spiderfoot/README.md)       | Reconnaissance     | [spiderfoot](https://github.com/smicallef/spiderfoot)                       |
| [README](./composer/sec-tool-services/velociraptor/README.md)     | Forensics          | [velociraptor](https://github.com/Velocidex/velociraptor)                   |
| [README](./composer/sec-tool-services/web-check/README.md)        | Web Security       | [web-check](https://github.com/Lissy93/web-check)                           |
| [README](./composer/sys-tools/ittools/README.md)                  | Tooling            | [ittools](https://github.com/CorentinTh/it-tools)                           |
| - (not added yet)                                                 | Terminal           | [Termix](https://github.com/LukeGus/Termix)                                 |
| &nbsp;                                                            | &nbsp;             | &nbsp;                                                                      |
| &nbsp;                                                            | &nbsp;             | [robin](https://github.com/apurvsinghgautam/robin)                          |

---

## Collection Status

`up-to-date` means a focused stack change in the last ~4 months. Dockerfile-only changes and repository-wide commits touching at least six stacks are not counted as focused maintenance.

| column   | meaning                                                                                                   |
| -------- | --------------------------------------------------------------------------------------------------------- |
| `ver`    | image tag pinned as default in `docker-compose.yaml` (- = `latest`/unpinned)                              |
| `last`   | `YYYY-MM` of the most recent focused stack change                                                         |
| `status` | 🟢 focused ≤ ~4 months · 🟡 older ~4–12 months · 🔴 stale > ~1 year · 🟠 bulk-only · ⚫ archived · 🆕 new |
| `tpl`    | matches `__template/`: `yes` · `±` partial · `no` hand-rolled · `custom`                                  |

> 🔴 `stale` does **not** mean broken - many of these still run fine. It flags stacks without a focused commit for over a year that deserve a review/version bump before (re)use.

## Guides & Runbooks

- **Base template** - [`__template/`](./__template/README.md) is the canonical skeleton for new stacks (anchors `basic-deploy-labels`, `basic-deploy`, `basic`).

## Best Practice Start-Up

Use docker-swarm to manage and start containers.  
For that, each service is configured as follows:

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

To start this configuration with all support between docker-stack and docker-compose, run it as follows:  
Create alias for `docker-swarm` command:

> _Find aliases also here: [.dotfiles](https://github.com/MVladislav/.dotfiles/blob/7c928dc65c273021799314d0c373c73c88d3feac/zsh/zshrc-append#L124)_

```sh
alias docker='DOCKER_BUILDKIT=1 docker'
alias docker-compose='docker compose'
alias docker-swarm-compose='docker compose --compatibility config | sed 's|cpus: \([0-9]\+\(\.[0-9]\+\)*\)|cpus: "\1"|' | sed '1{/^name:/d}' | sed 's/published: "\(.*\)"/published: \1/' | docker stack deploy --resolve-image=never --with-registry-auth --detach=false --compose-file -'
alias docker-swarm='docker compose --compatibility config | sed 's|cpus: \([0-9]\+\(\.[0-9]\+\)*\)|cpus: "\1"|' | sed '1{/^name:/d}' | sed 's/published: "\(.*\)"/published: \1/' | docker stack deploy --resolve-image=always --with-registry-auth --detach=false --compose-file -'
```

And run:

```sh
docker-swarm-compose <STACK_NAME>
```

---

## References

- [\_\_template](./__template/README.md) - base configuration and templates for new stacks
- [Docker Compose file reference](https://docs.docker.com/compose/compose-file/)
- [Traefik documentation](https://doc.traefik.io)
- [Discussions](https://github.com/MVladislav/vm-docker-collection/discussions)

---

**☕ COFFEE is a HUG in a MUG ☕**
