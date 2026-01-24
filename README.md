# Docker Collection

---

- [Docker Collection](#docker-collection)
  - [best practice start-up](#best-practice-start-up)
  - [References](#references)

---

A docker collection with composer for a fast start-up.

- Each service folder has its own **README**.

| topic                 | type                  | name                                                                                                | description                                                                         |
| :-------------------- | :-------------------- | :-------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------- |
| **ai**                |                       |                                                                                                     |                                                                                     |
|                       | AI                    | ~~[ai-text-generation-webui](https://github.com/oobabooga/text-generation-webui)~~                  | Web interface for AI text generation models.                                        |
|                       | AI                    | [claude-code](https://github.com/anthropics/claude-code)                                            | Agentic coding tool that lives in your terminal.                                    |
|                       | AI                    | [ollama](https://github.com/ollama/ollama)                                                          | AI-powered automation and productivity tool.                                        |
|                       | AI                    | [opencode](https://github.com/anomalyco/opencode)                                                   | Open source coding agent.                                                           |
| **dev**               |                       |                                                                                                     |                                                                                     |
|                       | CMS                   | [cms_typo3](https://get.typo3.org/#download)                                                        | Content management system for building and managing websites.                       |
|                       | IDE                   | [code-server](https://github.com/coder/code-server)                                                 | Cloud-based development environment running Visual Studio Code.                     |
|                       | IDE                   | [coder](https://coder.com/docs/install/docker)                                                      | Collaborative development environment.                                              |
|                       | Programming Tool      | [compiler-explorer](https://github.com/compiler-explorer/compiler-explorer)                         | Web-based tool for exploring compiler output for various languages.                 |
|                       | CI/CD                 | ~~[jenkins](https://www.jenkins.io/doc/book/installing/docker)~~                                    | Automation server for continuous integration and delivery.                          |
|                       | OS                    | ~~[win](https://github.com/dockur/windows)~~                                                        | Windows inside a Docker container.                                                  |
| **helper**            |                       |                                                                                                     |                                                                                     |
|                       | Cert                  | [acme](https://github.com/acmesh-official/acme.sh)                                                  | Client for SSL / TLS certificate automation.                                        |
|                       | Dashboard             | [dashy](https://github.com/Lissy93/dashy)                                                           | A customizable personal dashboard for organizing web services and links.            |
|                       | Updater               | [diun](https://github.com/crazy-max/diun)                                                           | Receive notifications when an image is updated on a Docker registry.                |
|                       | Container Manager     | ~~[dockge](https://github.com/louislam/dockge)~~                                                    | Docker project for generic setups and experiments.                                  |
|                       | Dashboard             | [glance](https://github.com/glanceapp/glance)                                                       | A self-hosted dashboard that puts all your feeds in one place.                      |
|                       | Dashboard             | [heimdall](https://github.com/linuxserver/Heimdall)                                                 | A web-based dashboard for organizing application links.                             |
|                       | Dashboard             | [homepage](https://github.com/gethomepage/homepage)                                                 | A static start page for personal links and dashboards.                              |
|                       | Automation            | [kestra](https://github.com/kestra-io/kestra)                                                       | Event Driven Orchestration & Scheduling Platform for Mission Critical Applications. |
|                       | Automation            | [n8n](https://github.com/n8n-io/n8n)                                                                | Workflow automation platform with native AI capabilities.                           |
|                       | Container Manager     | [portainer](https://github.com/portainer/portainer-compose)                                         | Web-based Docker container management tool.                                         |
|                       | Proxy                 | [traefik](https://doc.traefik.io)                                                                   | Cloud-native reverse proxy and load balancer for Docker and Kubernetes.             |
| **monitoring**        |                       |                                                                                                     |                                                                                     |
|                       | Monitoring            | [beszel](https://github.com/henrygd/beszel)                                                         | Lightweight server monitoring hub with historical data, docker stats, and alerts.   |
|                       | Monitoring            | [checkmate](https://github.com/bluewave-labs/Checkmate)                                             | Track and monitor server hardware, uptime, response times, and incidents.           |
|                       | Monitoring            | [checkmk](https://checkmk.com/de)                                                                   | IT monitoring software for servers, applications, and networks.                     |
|                       | Webhook               | [gotify](https://github.com/gotify/server)                                                          | A simple server for sending and receiving messages.                                 |
|                       | Monitoring            | [librenms](https://github.com/librenms/librenms)                                                    | Network monitoring system for tracking device performance and metrics.              |
|                       | Network Analysis      | ~~[ntopng](https://github.com/ntop/docker-ntop)~~                                                   | High-performance network traffic analysis and monitoring tool.                      |
|                       | Monitoring            | [observium](https://observium.org)                                                                  | Auto-discovering network monitoring platform for tracking network health.           |
|                       | Monitoring            | [pandorafms](https://hub.docker.com/r/pandorafms/pandorafms-open-stack-el8)                         | Flexible monitoring system for infrastructure and applications.                     |
|                       | Updater               | [patchmon](https://github.com/PatchMon/PatchMon)                                                    | Linux Patch Monitoring Automation Platform                                          |
|                       | Monitoring            | [prometheus](https://hub.docker.com/r/prom/prometheus)                                              | Open-source monitoring system and time-series database.                             |
|                       | Monitoring            | [pulse](https://github.com/rcourtman/Pulse)                                                         | Real-time monitoring for Proxmox, Docker, and Kubernetes.                           |
|                       | Monitoring            | [speedtest-tracker](https://github.com/alexjustesen/speedtest-tracker)                              | Tool for tracking internet speed test results over time.                            |
|                       | Monitoring            | [uptime_kuma](https://github.com/louislam/uptime-kuma)                                              | Self-hosted monitoring tool for tracking service availability.                      |
|                       | Monitoring            | [zabbix](https://github.com/zabbix/zabbix-docker)                                                   | Containerized Zabbix for IT infrastructure monitoring.                              |
| **other**             |                       |                                                                                                     |                                                                                     |
|                       | Transcoder            | [automatic-ripping-machine](https://github.com/automatic-ripping-machine/automatic-ripping-machine) | Automatic Ripping Machine (ARM) Scripts.                                            |
|                       | GEO                   | [dawarich](https://github.com/Freika/dawarich)                                                      | Self-hosted alternative to Google Location History.                                 |
|                       | Collaboration         | [focalboard](https://github.com/mattermost/focalboard)                                              | Open-source project management software.                                            |
|                       |                       | github-stats                                                                                        |                                                                                     |
|                       | Network Emulator      | ~~[gns3server](https://github.com/GNS3/gns3-server)~~                                               | Network simulation software for labs and testing.                                   |
|                       | Scanner               | [intercept](https://github.com/smittix/intercept)                                                   | Platform that unites signal intelligence tools into a single interface.             |
|                       | Webcam Tool           | [Linux-Fake-Background-Webcam](https://github.com/fangfufu/Linux-Fake-Background-Webcam)            | Simulates a virtual webcam with custom background.                                  |
|                       | Note-taking           | [logseq](https://github.com/logseq/logseq)                                                          | Privacy-first knowledge base and note-taking app.                                   |
|                       | PBX                   | ~~[mikopbx](https://github.com/mikopbx/Core)~~                                                      | Open-source Private Branch Exchange (PBX) system.                                   |
|                       |                       | [mirotalk-p2p](https://github.com/miroslavpejic85/mirotalk)                                         | Real-Time Video Conferences.                                                        |
|                       | Document Manager      | [paperless-ngx](https://github.com/paperless-ngx/paperless-ngx)                                     | Document management system for scanning and organizing digital documents.           |
|                       |                       | ~~requestly~~                                                                                       |                                                                                     |
|                       | Appointment Scheduler | ~~[thunderbird-appointment](https://github.com/thunderbird/appointment)~~                           | Make appointments as easy as it gets.                                               |
|                       |                       | [yamtrack](https://github.com/FuzzyGrim/Yamtrack)                                                   | Media tracker.                                                                      |
| **privacy**           |                       |                                                                                                     |                                                                                     |
|                       | DNS/DDNS              | [cloudflare-ddns](https://hub.docker.com/r/oznu/cloudflare-ddns)                                    | Dynamic DNS tool for Cloudflare DNS management.                                     |
|                       | Tunneling             | [cloudflare-tunnel](https://hub.docker.com/r/cloudflare/cloudflared)                                | Secure tunneling for accessing services behind NAT or firewall.                     |
|                       | VPN                   | ~~[netbird](https://github.com/netbirdio/netbird)~~                                                 | Secure WireGuard-based overlay network with SSO, MFA and granular access controls.  |
|                       | VPN                   | [netmaker](https://docs.netmaker.org/quick-start.html)                                              | Mesh VPN management and networking tool.                                            |
|                       | VPN                   | [openvpn](https://openvpn.net/)                                                                     | Open-source VPN for secure remote access.                                           |
|                       | Proxy                 | [pangolin](https://github.com/fosrl)                                                                | Secure access to your private networks, no open ports required.                     |
|                       | Proxy                 | [snowflake-proxy](https://gitlab.torproject.org/tpo/anti-censorship/docker-snowflake-proxy)         | Proxy to bypass internet censorship.                                                |
|                       | SSH Gateway           | [teleport](https://goteleport.com)                                                                  | Secure access gateway for SSH and Kubernetes.                                       |
|                       | VPN                   | [wireguard-easy](https://github.com/wg-easy/wg-easy)                                                | Easy setup and management for WireGuard VPN.                                        |
|                       | VPN                   | [wireguard-ui](https://github.com/ngoduykhanh/wireguard-ui)                                         | User interface for managing WireGuard VPN configurations.                           |
| **sec**               |                       |                                                                                                     |                                                                                     |
|                       | Security              | [faraday](https://github.com/infobyte/faraday)                                                      | Collaborative penetration testing and vulnerability management platform.            |
|                       | Malware Detection     | [linux-malware-detect](https://github.com/rfxn/linux-malware-detect)                                | Malware detection tool for Linux systems.                                           |
|                       | Vulnerability         | [nessus](https://hub.docker.com/r/tenableofficial/nessus)                                           | Comprehensive vulnerability scanning tool.                                          |
|                       | Vulnerability         | [nexpose](https://docs.rapid7.com/nexpose/install)                                                  | Security vulnerability management tool.                                             |
|                       | Tunneling             | [ngrok](https://ngrok.com)                                                                          | Secure tunnels for exposing local servers to the internet.                          |
|                       | Vulnerability         | [openvas](https://hub.docker.com/r/greenbone/openvas-scanner)                                       | Open-source vulnerability assessment scanner.                                       |
|                       | Security              | [portspoof](https://github.com/strandjs/IntroLabs)                                                  | Tool for preventing port scans by simulating fake services.                         |
|                       | IDS                   | [suricata](https://github.com/OISF/suricata)                                                        | Open-source intrusion detection and prevention system.                              |
| **sec-tool-cls**      |                       |                                                                                                     |                                                                                     |
|                       | Collection            | [bounty-collection](https://github.com/MVladislav/vm-docker-collection)                             | Collection of tools for bug bounty hunting and security research.                   |
|                       | Security Benchmark    | [docker-bench-security](https://github.com/docker/docker-bench-security)                            | Tool for checking security best practices for Docker.                               |
|                       | Phishing              | [evilginx2](https://github.com/kgretzky/evilginx2)                                                  | Advanced phishing attack framework.                                                 |
|                       | Password Cracking     | [hashcat](https://github.com/hashcat/hashcat)                                                       | Open-source password recovery tool.                                                 |
|                       | Exploitation          | [metasploit](https://github.com/rapid7/metasploit-framework)                                        | Comprehensive penetration testing framework.                                        |
|                       | Networking            | [netexec](https://github.com/Pennyw0rth/NetExec)                                                    | Network command execution tool.                                                     |
|                       | Scanning              | [nuclei](https://github.com/projectdiscovery/nuclei)                                                | Fast vulnerability scanner based on templates.                                      |
|                       | Social Engineering    | [set](https://github.com/trustedsec/social-engineer-toolkit)                                        | Social-Engineer Toolkit for penetration testing.                                    |
|                       | Exploitation          | [villain](https://github.com/t3l3machus/villain)                                                    | Multi-functional payload delivery framework.                                        |
|                       | Network Analysis      | [zeek](https://github.com/zeek/zeek)                                                                | Powerful network analysis framework.                                                |
| **sec-tool-services** |                       |                                                                                                     |                                                                                     |
|                       | Attack Mapping        | [attack-navigator](https://github.com/mitre-attack/attack-navigator)                                | Tool for visualizing and mapping MITRE ATT&CK techniques.                           |
|                       | Security              | ~~[bloodhound](https://github.com/SpecterOps/BloodHound)~~                                          | Active Directory (AD) enumeration and attack path discovery tool.                   |
|                       | Analysis              | [caido](https://github.com/caido/caido)                                                             | Analysis tool for security assessments.                                             |
|                       | Attack Mapping        | [dependencytrack](https://github.com/DependencyTrack/dependency-track)                              | Intelligent Component Analysis platform, identify and reduce risk.                  |
|                       | Phishing              | [gophish](https://github.com/gophish/gophish)                                                       | Open-source phishing simulation toolkit.                                            |
|                       | Web Screenshots       | [gowitness](https://github.com/sensepost/gowitness)                                                 | Tool for capturing screenshots of web services.                                     |
|                       | CTI                   | [opencti](https://github.com/OpenCTI-Platform/docker)                                               | Cyber Threat Intelligence (CTI) platform.                                           |
|                       | Checklist Tool        | ~~[personal-security-checklist](https://github.com/Lissy93/personal-security-checklist)~~           | Personal security checklist generator and manager.                                  |
|                       |                       | ~~[scnr](https://github.com/scnr/installer)~~                                                       | The all-seeing web application security scanner.                                    |
|                       | Reconnaissance        | [spiderfoot](https://github.com/smicallef/spiderfoot)                                               | Automated OSINT tool for gathering intelligence.                                    |
|                       | Forensics             | [velociraptor](https://github.com/Velocidex/velociraptor)                                           | Endpoint visibility and forensic tool.                                              |
|                       | Web Security          | [web-check](https://github.com/Lissy93/web-check)                                                   | Automated web application security scanner.                                         |
| **siem**              |                       |                                                                                                     |                                                                                     |
|                       | Threat Detection      | [crowdsec](https://crowdsec.net)                                                                    | Collaborative cybersecurity tool for threat detection.                              |
|                       | Analytics             | [grafana](https://grafana.com)                                                                      | Open-source platform for monitoring and observability dashboards.                   |
|                       | SIEM                  | [graylog](https://github.com/Graylog2/graylog-docker)                                               | Centralized log management and analysis tool.                                       |
|                       | Time-series DB        | [influxdb](https://hub.docker.com/_/influxdb)                                                       | High-performance time-series database.                                              |
|                       | Endpoint Security     | [sophos](https://github.com/sophos/Sophos-Central-SIEM-Integration)                                 | Advanced endpoint security and management tool.                                     |
|                       | SIEM                  | [splunk](https://hub.docker.com/r/splunk/splunk)                                                    | Enterprise-level security information and event management tool.                    |
|                       | Monitoring            | [telegraf](https://github.com/influxdata/telegraf)                                                  | Metrics collection and reporting agent for InfluxDB.                                |
|                       | Incident Response     | ~~[thehive](https://github.com/StrangeBeeCorp/docker)~~                                             | Open-source Security Incident Response Platform (SIRP).                             |
|                       | Incident Response     | ~~[thehive4](https://github.com/TheHive-Project/Docker-Templates)~~                                 | Enhanced version of TheHive for incident response.                                  |
|                       | SIEM                  | [wazuh](https://github.com/wazuh/wazuh-docker)                                                      | Open-source security monitoring and compliance tool.                                |
| **smart**             |                       |                                                                                                     |                                                                                     |
|                       | Energy                | [akkudoktor](https://github.com/Akkudoktor-EOS/EOS)                                                 | Tool for monitoring battery health and performance.                                 |
|                       | Energy                | [evcc](https://github.com/evcc-io/evcc)                                                             | EV Charge Controller and home energy management system.                             |
|                       | Household             | [grocy](https://github.com/grocy/grocy)                                                             | Groceries & household management solution for your home.                            |
|                       | Recipe Manager        | [mealie](https://github.com/mealie-recipes/mealie)                                                  | Self-hosted recipe management and meal-planning application.                        |
| **sys-admin**         |                       |                                                                                                     |                                                                                     |
|                       | Boot Management       | [netboot](https://github.com/netbootxyz/docker-netbootxyz)                                          | PXE boot server for managing network bootable systems.                              |
|                       | IP Management         | [netbox](https://github.com/netbox-community/netbox-docker)                                         | IP address management and data center infrastructure modeling.                      |
|                       | Remote Desktop        | [rustdesk](https://github.com/rustdesk/rustdesk-server)                                             | Open-source remote desktop software with self-hosted server.                        |
|                       | Asset Management      | [snipe-it](https://github.com/snipe/snipe-it)                                                       | Open-source IT asset management tool.                                               |
| **sys-backup**        |                       |                                                                                                     |                                                                                     |
|                       | Backup                | [open-archiver](https://github.com/LogicLabs-OU/OpenArchiver)                                       | Legally compliant email archiving.                                                  |
|                       | File Sync             | [syncthing](https://github.com/syncthing/syncthing)                                                 | Continuous file synchronization tool.                                               |
|                       | Backup                | [zerobyte](https://github.com/nicotsx/zerobyte)                                                     | Backup automation.                                                                  |
| **sys-design**        |                       |                                                                                                     |                                                                                     |
|                       | Diagramming           | [drawio](https://github.com/jgraph/docker-drawio)                                                   | Web-based diagramming tool for creating flowcharts and designs.                     |
|                       | Diagramming           | [excalidraw](https://github.com/excalidraw/excalidraw)                                              | Open-source sketching and diagramming tool.                                         |
|                       | Diagramming           | [penpot](https://help.penpot.app/technical-guide/getting-started/#install-with-docker)              | design & prototype platform that is deployment agnostic.                            |
| **sys-finance**       |                       |                                                                                                     |                                                                                     |
|                       | Budgeting             | [actual-budget](https://github.com/actualbudget/actual)                                             | Open-source personal budgeting software.                                            |
|                       | Budgeting             | [erpnext](https://github.com/frappe/erpnext)                                                        | Free and Open Source Enterprise Resource Planning (ERP) .                           |
|                       | Budgeting             | [firefly-iii](https://github.com/firefly-iii/docker)                                                | Personal finance and budgeting manager.                                             |
|                       | Budgeting             | [InvoiceShelf](https://github.com/InvoiceShelf/docker)                                              | Open-source invoicing software.                                                     |
|                       |                       | ~~[openbudgeteer](https://github.com/TheAxelander/OpenBudgeteer)~~                                  |                                                                                     |
|                       |                       | ~~[payme](https://github.com/cachebag/payme)~~                                                      |                                                                                     |
|                       |                       | ~~[saldoify](https://github.com/Raihan-Software/saldoify)~~                                         |                                                                                     |
| **sys-infra**         |                       |                                                                                                     |                                                                                     |
|                       | Note-taking           | [affine](https://github.com/toeverything/AFFiNE)                                                    | Vector graphic design and diagramming tool.                                         |
|                       |                       | ~~[appflowy](https://github.com/AppFlowy-IO/AppFlowy-Cloud)~~                                       |                                                                                     |
|                       | Appointment Scheduler | [calcom](https://github.com/calcom/cal.com)                                                         | Scheduling infrastructure for absolutely everyone.                                  |
|                       | Note-taking           | [docmost](https://github.com/docmost/docmost)                                                       | Collaborative wiki and documentation software.                                      |
|                       | Appointment Scheduler | [easyappointments](https://github.com/alextselegidis/easyappointments)                              | Self Hosted Appointment Scheduler.                                                  |
|                       | File Management       | [filebrowser](https://github.com/filebrowser/filebrowser)                                           | Lightweight file management tool for web servers.                                   |
|                       | CMS                   | [ghost](https://hub.docker.com/_/ghost)                                                             | Open-source publishing platform for blogs and content.                              |
|                       | Photo Organizer       | [immich](https://github.com/immich-app/immich)                                                      | Self-hosted photo and video storage and management.                                 |
|                       | Time Tracking         | [kimai](https://github.com/kimai/kimai)                                                             | Time-tracking software for freelancers and teams.                                   |
|                       | Email Marketing       | [listmonk](https://listmonk.app)                                                                    | High-performance self-hosted newsletter and mailing list manager.                   |
|                       | Cloud Storage         | [nextcloud](https://github.com/nextcloud/docker)                                                    | Open-source file sharing and collaboration platform.                                |
|                       | Cloud Storage         | [nextcloud-aio](https://github.com/nextcloud/all-in-one)                                            | All-in-one Dockerized Nextcloud solution.                                           |
|                       | Project Management    | [odoo](https://www.odoo.com/app/project)                                                            | Odoo app for managing projects and tasks.                                           |
|                       |                       | ~~[onlyoffice](https://github.com/ONLYOFFICE/Docker-CommunityServer)~~                              |                                                                                     |
|                       | Project Management    | [openproject](https://github.com/opf/openproject-deploy)                                            | Open-source project management software.                                            |
|                       | Cloud Storage         | [owncloud](https://hub.docker.com/r/owncloud/server)                                                | Enterprise file sharing and collaboration platform.                                 |
|                       | Project Management    | [plane](https://github.com/makeplane/plane)                                                         | Helps you track your issues, epics, and cycles the easiest way on the planet.       |
|                       |                       | ~~proxmox-pdm~~                                                                                     |                                                                                     |
| **sys-security**      |                       |                                                                                                     |                                                                                     |
|                       | Password Manager      | [bitwarden](https://github.com/bitwarden/server)                                                    | Open-source password management solution.                                           |
|                       | Identity Platform     | [goauthentik](https://github.com/goauthentik/authentik)                                             | Open-source identity and access management system.                                  |
|                       | Password Manager      | [passbolt](https://hub.docker.com/r/passbolt/passbolt)                                              | Team-based password management platform.                                            |
| **sys-tools**         |                       |                                                                                                     |                                                                                     |
|                       | News Aggregator       | [freshrss](https://github.com/FreshRSS/FreshRSS)                                                    | Self-hosted RSS feed reader.                                                        |
|                       | Tooling               | [IT-Tools](https://github.com/CorentinTh/it-tools)                                                  | Useful tools for developer and people working in IT.                                |
|                       | Tooling               | [omni-tools](https://github.com/iib0011/omni-tools)                                                 |                                                                                     |
|                       | Speed Testing         | [openspeedtest](https://hub.docker.com/r/openspeedtest)                                             | Self-hosted internet speed testing tool.                                            |
|                       | Resume                | [Reactive-Resume](https://github.com/AmruthPillai/Reactive-Resume)                                  | A one-of-a-kind resume builder that keeps your privacy in mind.                     |
|                       | URL Shortener         | [shlink](https://hub.docker.com/r/shlinkio/shlink)                                                  | Self-hosted URL shortener and analytics tool.                                       |
|                       | PDF Tool              | [stirling-pdf](https://github.com/Stirling-Tools/Stirling-PDF)                                      | Tool for PDF document manipulation and editing.                                     |
| **POSSIBLE LATER**    |                       |                                                                                                     |                                                                                     |
|                       | \*Container Manager   | [komodo](https://github.com/moghtech/komodo)                                                        | A tool to build and deploy software on many servers.                                |
|                       | \*URL Shortener       | [kutt](https://github.com/thedevs-network/kutt)                                                     | Modern URL shortener with support for custom domains.                               |
|                       | Static Site Gen       | [quartz](https://github.com/jackyzha0/quartz)                                                       | static-site generator, transforms Markdown content into fully functional websites.  |
|                       | Static Site Gen       | [vitepress](https://github.com/vuejs/vitepress)                                                     | static site generator.                                                              |
|                       | Static Site Gen       | [pocketbase](https://github.com/pocketbase/pocketbase)                                              | Open Source realtime backend in 1 file.                                             |
|                       | \*VPN                 | [algo](https://github.com/trailofbits/algo)                                                         | Set up a personal VPN in the cloud.                                                 |
|                       | VPN                   | [WGDashboard](https://github.com/donaldzou/WGDashboard)                                             | Simple dashboard for WireGuard VPN.                                                 |
|                       | \*Proxy               | [zoraxy](https://github.com/tobychui/zoraxy)                                                        | HTTP reverse proxy and forwarding tool. Now written in Go!                          |
|                       | HRM                   | [orangehrm](https://github.com/orangehrm/orangehrm)                                                 |                                                                                     |
|                       | Ticketing System      | [zammad-docker-compose](https://docs.zammad.org/en/latest/install/docker-compose.html)              | Self-hosted ticketing and customer support system.                                  |
|                       | \*File Management     | [pydio-cells](https://github.com/pydio/cells)                                                       | Enterprise file sharing and collaboration platform.                                 |
|                       | Customer Support      | [chatwoot](https://github.com/chatwoot/chatwoot)                                                    | Open-source customer support and engagement platform.                               |
|                       | Monitoring            | [OpenTelemetry](https://opentelemetry.io/docs/demo/docker-deployment)                               | High-quality, ubiquitous, and portable telemetry to enable effective observability. |
|                       | Monitoring            | [sensu-go](https://github.com/sensu/sensu-go)                                                       | Simple. Scalable. Multi-cloud monitoring.                                           |
|                       | Collaboration         | [mattermost](https://github.com/mattermost/mattermost)                                              | Open-source messaging and collaboration platform.                                   |
|                       | Collaboration         | [codimd](https://github.com/hackmdio/codimd)                                                        | Open-source real-time collaborative markdown editor.                                |
|                       | Identity Platform     | [zentyal](https://zentyal.com)                                                                      | Join Win-Clients to the domain and manage them transparently.                       |
|                       | Task Management       | [vikunja](https://kolaente.dev/vikunja)                                                             | Open-source project and task management tool.                                       |
|                       | Git Hosting           | [gitea](https://docs.gitea.com/installation/install-with-docker)                                    | Lightweight, self-hosted Git service.                                               |
|                       | Reporting             | [BugZilla](https://github.com/bugzilla/bugzilla)                                                    | The software solution designed to drive software development.                       |
|                       | Testing               | [netpicker](https://github.com/netpicker/netpicker)                                                 | Test your network compliance, design and security.                                  |
|                       | \*Wiki                | [wiki.js](https://github.com/requarks/wiki)                                                         | A modern and powerful wiki app built on Node.js.                                    |
|                       | \*Wiki                | [outline](https://github.com/outline/outline)                                                       | The fastest knowledge base for growing teams.                                       |
|                       | Wiki                  | [BookStack](https://github.com/BookStackApp/BookStack)                                              | A platform to create documentation/wiki content.                                    |
|                       | CRM                   | [twenty](https://github.com/twentyhq/twenty)                                                        | Building a modern alternative to Salesforce, powered by the community.              |
|                       | Wealth                | [ghostfolio](https://github.com/ghostfolio/ghostfolio)                                              | Open Source Wealth Management Software.                                             |
|                       |                       | [NetAlertX](https://github.com/jokob-sk/NetAlertX)                                                  | Network intruder and presence detector.                                             |
|                       | Webhook               | [Operational](https://github.com/operational-co/operational.co)                                     | Track important events and receive push notifications.                              |
|                       |                       | [urlaubsverwaltung](https://github.com/urlaubsverwaltung/urlaubsverwaltung)                         | Urlaubsverwaltung.                                                                  |
|                       |                       |                                                                                                     |                                                                                     |
|                       |                       | [linkarr](https://github.com/itsmejoeeey/linkarr)                                                   |                                                                                     |
|                       |                       | [cronmaster](https://github.com/fccview/cronmaster)                                                 |                                                                                     |
|                       |                       | [HarborGuard](https://github.com/HarborGuard/HarborGuard)                                           |                                                                                     |
|                       |                       | [discourse](https://github.com/discourse/discourse)                                                 |                                                                                     |
|                       |                       |                                                                                                     |                                                                                     |
|                       | AI                    | [Bytebot](https://github.com/bytebot-ai/bytebot)                                                    |                                                                                     |
|                       | AI                    | [airi](https://github.com/moeru-ai/airi)                                                            |                                                                                     |
|                       | \*Analytics           | [Rybbit](https://github.com/rybbit-io/rybbit)                                                       |                                                                                     |
|                       | Email Marketing       | [BillionMail](https://github.com/aaPanel/BillionMail)                                               |                                                                                     |
|                       |                       | [HeadlessX](https://github.com/saifyxpro/HeadlessX)                                                 |                                                                                     |
|                       |                       | [HomeHub](https://github.com/surajverma/homehub)                                                    |                                                                                     |
|                       |                       | [Glass-Keep](https://github.com/nikunjsingh93/react-glass-keep)                                     |                                                                                     |
|                       |                       | [Dockpeek](https://github.com/dockpeek/dockpeek)                                                    |                                                                                     |
|                       |                       | [Termix](https://github.com/LukeGus/Termix)                                                         |                                                                                     |
|                       |                       | [SurfSense](https://github.com/MODSetter/SurfSense)                                                 |                                                                                     |
|                       | Monitoring            | [komari](https://github.com/komari-monitor/komari)                                                  |                                                                                     |
|                       |                       | [PigeonPod](https://github.com/aizhimou/pigeon-pod)                                                 |                                                                                     |
|                       | \*Tooling             | [BentoPDF](https://github.com/alam00000/bentopdf)                                                   |                                                                                     |
|                       |                       | [Dispatcharr](https://github.com/Dispatcharr/Dispatcharr)                                           |                                                                                     |
|                       |                       | [Foxel](https://github.com/DrizzleTime/Foxel)                                                       |                                                                                     |
|                       | URL Shortener         | [chhoto-url](https://github.com/SinTan1729/chhoto-url)                                              |                                                                                     |
|                       |                       | [CommonForms](https://github.com/jbarrow/commonforms)                                               |                                                                                     |
|                       |                       |                                                                                                     |                                                                                     |
|                       |                       | [ElevenLabs UI](https://github.com/elevenlabs/ui)                                                   |                                                                                     |
|                       | ?                     | [Dexter](https://github.com/virattt/dexter)                                                         |                                                                                     |
|                       |                       | [Firm](https://github.com/42futures/firm)                                                           |                                                                                     |
|                       |                       | [FullstackAgent](https://github.com/FullstackAgent/FullstackAgent)                                  |                                                                                     |
|                       |                       | [Open Computer Use](https://github.com/LLmHub-dev/open-computer-use)                                |                                                                                     |
|                       | -                     | [TinyRecursiveModels](https://github.com/SamsungSAILMontreal/TinyRecursiveModels)                   |                                                                                     |
|                       | -                     | [Neura Hustle Tracker](https://github.com/adolfousier/neura-hustle-tracker)                         |                                                                                     |
|                       | -                     | [Puffin](https://github.com/KangLiao929/Puffin)                                                     |                                                                                     |
|                       | -                     | [Cronboard](https://github.com/antoniorodr/Cronboard)                                               |                                                                                     |
|                       | -                     | [Pyversity](https://github.com/Pringled/pyversity)                                                  |                                                                                     |
|                       | -                     | [Blaze](https://github.com/wizenheimer/blaze)                                                       |                                                                                     |
|                       | -                     | [Keyer](https://github.com/mafik/keyer)                                                             |                                                                                     |
|                       | -                     | [Everywhere](https://github.com/DearVa/Everywhere)                                                  |                                                                                     |
|                       | -                     | [Mina Rich Editor](https://github.com/Mina-Massoud/Mina-Rich-Editor)                                |                                                                                     |
|                       | -                     | [Stable Video Infinity](https://github.com/vita-epfl/Stable-Video-Infinity)                         |                                                                                     |
|                       | -                     | [Sora MCP Server](https://github.com/Doriandarko/sora-mcp)                                          |                                                                                     |
|                       |                       |                                                                                                     |                                                                                     |
|                       |                       | [ThinkDashboard](https://github.com/MatiasDesuu/ThinkDashboard)                                     |                                                                                     |
|                       |                       | [mainline-nextjs-template](https://github.com/shadcnblocks/mainline-nextjs-template)                |                                                                                     |
|                       |                       | [portfolio](https://github.com/NotStark/portfolio)                                                  |                                                                                     |
|                       |                       | [WithAnyone](https://github.com/Doby-Xu/WithAnyone)                                                 |                                                                                     |
|                       |                       |                                                                                                     |                                                                                     |
|                       |                       | [arpwatch](https://github.com/brandonleegit/arpwatch)                                               |                                                                                     |
|                       |                       | [SmokePing](https://github.com/oetiker/SmokePing)                                                   |                                                                                     |
|                       |                       | [logforge](https://github.com/log-forge/logforge)                                                   |                                                                                     |
|                       | Photo Organizer       | [photonix](https://github.com/photonixapp/photonix)                                                 | Self-hosted photo management and gallery system.                                    |
|                       | Transcoder            | [tdarr_old](https://github.com/haveagitgat/tdarr)                                                   | Media transcoding and management tool.                                              |

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
