# Docker Collection

---

- [Docker Collection](#docker-collection)
  - [best practice start-up](#best-practice-start-up)
  - [References](#references)

---

A docker collection with composer for a fast start-up.

- Each service folder has its own **README**.

| topic                 | type               | name                                                                                        | description                                                                         |
| :-------------------- | :----------------- | :------------------------------------------------------------------------------------------ | :---------------------------------------------------------------------------------- |
| **dev**               |                    |                                                                                             |                                                                                     |
|                       | Automation Tool    | ansible                                                                                     | Configuration management and automation tool for deploying applications.            |
|                       | CMS                | [cms_typo3](https://get.typo3.org/#download)                                                | Content management system for building and managing websites.                       |
|                       | IDE                | [code-server](https://github.com/coder/code-server)                                         | Cloud-based development environment running Visual Studio Code.                     |
|                       | Programming Tool   | [compiler-explorer](https://github.com/compiler-explorer/compiler-explorer)                 | Web-based tool for exploring compiler output for various languages.                 |
|                       | CI/CD              | [jenkins](https://www.jenkins.io/doc/book/installing/docker)                                | Automation server for continuous integration and delivery.                          |
| **helper**            |                    |                                                                                             |                                                                                     |
|                       | Dashboard          | [dashy](https://github.com/Lissy93/dashy)                                                   | A customizable personal dashboard for organizing web services and links.            |
|                       | Dashboard          | [heimdall](https://github.com/linuxserver/Heimdall)                                         | A web-based dashboard for organizing application links.                             |
|                       | Dashboard          | [homepage](https://github.com/gethomepage/homepage)                                         | A static start page for personal links and dashboards.                              |
|                       | Container Manager  | [portainer](https://github.com/portainer/portainer-compose)                                 | Web-based Docker container management tool.                                         |
|                       | Reverse Proxy      | [traefik](https://doc.traefik.io)                                                           | Cloud-native reverse proxy and load balancer for Docker and Kubernetes.             |
| **monitoring**        |                    |                                                                                             |                                                                                     |
|                       | Monitoring         | [beszel](https://github.com/henrygd/beszel)                                                 | Lightweight server monitoring hub with historical data, docker stats, and alerts.   |
|                       | Monitoring         | [checkmk](https://checkmk.com/de)                                                           | IT monitoring software for servers, applications, and networks.                     |
|                       | webhook            | [gotify](https://github.com/gotify/server)                                                  | A simple server for sending and receiving messages.                                 |
|                       | Monitoring         | [librenms](https://github.com/librenms/librenms)                                            | Network monitoring system for tracking device performance and metrics.              |
|                       | Monitoring         | [observium](https://observium.org)                                                          | Auto-discovering network monitoring platform for tracking network health.           |
|                       | Monitoring         | [pandorafms](https://hub.docker.com/r/pandorafms/pandorafms-open-stack-el8)                 | Flexible monitoring system for infrastructure and applications.                     |
|                       | Monitoring         | [prometheus](https://hub.docker.com/r/prom/prometheus)                                      | Open-source monitoring system and time-series database.                             |
|                       | Monitoring         | [speedtest-tracker](https://github.com/alexjustesen/speedtest-tracker)                      | Tool for tracking internet speed test results over time.                            |
|                       | Monitoring         | [uptime_kuma](https://github.com/louislam/uptime-kuma)                                      | Self-hosted monitoring tool for tracking service availability.                      |
| **other**             |                    |                                                                                             |                                                                                     |
|                       | AI                 | [ai-text-generation-webui](https://github.com/oobabooga/text-generation-webui)              | Web interface for AI text generation models.                                        |
|                       | Security           | [bloodhound](https://github.com/SpecterOps/BloodHound)                                      | Active Directory (AD) enumeration and attack path discovery tool.                   |
|                       | GEO                | [dawarich](https://github.com/Freika/dawarich)                                              | Self-hosted alternative to Google Location History.                                 |
|                       | Development Tool   | [dockge](https://github.com/louislam/dockge)                                                | Docker project for generic setups and experiments.                                  |
|                       | Collaboration      | [focalboard](https://github.com/mattermost/focalboard)                                      | Open-source project management software.                                            |
|                       | CMS                | [ghost](https://hub.docker.com/_/ghost)                                                     | Open-source publishing platform for blogs and content.                              |
|                       | Network Emulator   | [gns3server](https://github.com/GNS3/gns3-server)                                           | Network simulation software for labs and testing.                                   |
|                       | Webcam Tool        | [Linux-Fake-Background-Webcam](https://github.com/fangfufu/Linux-Fake-Background-Webcam)    | Simulates a virtual webcam with custom background.                                  |
|                       | Note-taking        | [logseq](https://github.com/logseq/logseq)                                                  | Privacy-first knowledge base and note-taking app.                                   |
|                       | Recipe Manager     | [mealie](https://github.com/mealie-recipes/mealie)                                          | Self-hosted recipe management and meal-planning application.                        |
|                       | PBX                | [mikopbx](https://github.com/mikopbx/Core)                                                  | Open-source Private Branch Exchange (PBX) system.                                   |
|                       | AI                 | [ollama](https://github.com/ollama/ollama)                                                  | AI-powered automation and productivity tool.                                        |
|                       | Document Manager   | [paperless-ngx](https://github.com/paperless-ngx/paperless-ngx)                             | Document management system for scanning and organizing digital documents.           |
|                       | Checklist Tool     | [personal-security-checklist](https://github.com/Lissy93/personal-security-checklist)       | Personal security checklist generator and manager.                                  |
|                       | Photo Organizer    | [photonix](https://github.com/photonixapp/photonix)                                         | Self-hosted photo management and gallery system.                                    |
|                       | Media Organizer    | [tdarr_old](https://github.com/haveagitgat/tdarr)                                           | Media transcoding and management tool.                                              |
|                       | Incident Response  | [thehive](https://github.com/StrangeBeeCorp/docker)                                         | Open-source Security Incident Response Platform (SIRP).                             |
| **privacy**           |                    |                                                                                             |                                                                                     |
|                       | DNS/DDNS           | [cloudflare-ddns](https://hub.docker.com/r/oznu/cloudflare-ddns)                            | Dynamic DNS tool for Cloudflare DNS management.                                     |
|                       | Tunneling          | [cloudflare-tunnel](https://hub.docker.com/r/cloudflare/cloudflared)                        | Secure tunneling for accessing services behind NAT or firewall.                     |
|                       | VPN                | [netmaker](https://docs.netmaker.org/quick-start.html)                                      | Mesh VPN management and networking tool.                                            |
|                       | VPN                | [openvpn](https://openvpn.net/)                                                             | Open-source VPN for secure remote access.                                           |
|                       | Proxy              | [snowflake-proxy](https://gitlab.torproject.org/tpo/anti-censorship/docker-snowflake-proxy) | Proxy to bypass internet censorship.                                                |
|                       | VPN                | [wireguard-easy](https://github.com/WeeJeWel/wg-easy)                                       | Easy setup and management for WireGuard VPN.                                        |
|                       | VPN                | [wireguard-ui](https://github.com/ngoduykhanh/wireguard-ui)                                 | User interface for managing WireGuard VPN configurations.                           |
| **sec**               |                    |                                                                                             |                                                                                     |
|                       | Security           | [faraday](https://github.com/infobyte/faraday)                                              | Collaborative penetration testing and vulnerability management platform.            |
|                       | Malware Detection  | [linux-malware-detect](https://github.com/rfxn/linux-malware-detect)                        | Malware detection tool for Linux systems.                                           |
|                       | Vulnerability      | [nessus](https://hub.docker.com/r/tenableofficial/nessus)                                   | Comprehensive vulnerability scanning tool.                                          |
|                       | Vulnerability      | [nexpose](https://docs.rapid7.com/nexpose/install)                                          | Security vulnerability management tool.                                             |
|                       | Tunneling          | [ngrok](https://ngrok.com)                                                                  | Secure tunnels for exposing local servers to the internet.                          |
|                       | Vulnerability      | [openvas](https://hub.docker.com/r/greenbone/openvas-scanner)                               | Open-source vulnerability assessment scanner.                                       |
|                       | Security           | [portspoof](https://github.com/strandjs/IntroLabs)                                          | Tool for preventing port scans by simulating fake services.                         |
|                       | IDS                | [suricata](https://github.com/OISF/suricata)                                                | Open-source intrusion detection and prevention system.                              |
|                       | SSH Gateway        | [teleport](https://goteleport.com)                                                          | Secure access gateway for SSH and Kubernetes.                                       |
| **sec-tool-cls**      |                    |                                                                                             |                                                                                     |
|                       | Collection         | [bounty-collection](https://github.com/MVladislav/vm-docker-collection)                     | Collection of tools for bug bounty hunting and security research.                   |
|                       | Security Benchmark | [docker-bench-security](https://github.com/docker/docker-bench-security)                    | Tool for checking security best practices for Docker.                               |
|                       | Phishing           | [evilginx2](https://github.com/kgretzky/evilginx2)                                          | Advanced phishing attack framework.                                                 |
|                       | Password Cracking  | [hashcat](https://github.com/hashcat/hashcat)                                               | Open-source password recovery tool.                                                 |
|                       | Exploitation       | [metasploit](https://github.com/rapid7/metasploit-framework)                                | Comprehensive penetration testing framework.                                        |
|                       | Networking         | [netexec](https://github.com/Pennyw0rth/NetExec)                                            | Network command execution tool.                                                     |
|                       | Scanning           | [nuclei](https://github.com/projectdiscovery/nuclei)                                        | Fast vulnerability scanner based on templates.                                      |
|                       | Social Engineering | [set](https://github.com/trustedsec/social-engineer-toolkit)                                | Social-Engineer Toolkit for penetration testing.                                    |
|                       | Exploitation       | [villain](https://github.com/t3l3machus/villain)                                            | Multi-functional payload delivery framework.                                        |
|                       | Network Analysis   | [zeek](https://github.com/zeek/zeek)                                                        | Powerful network analysis framework.                                                |
| **sec-tool-services** |                    |                                                                                             |                                                                                     |
|                       | Attack Mapping     | [attack-navigator](https://github.com/mitre-attack/attack-navigator)                        | Tool for visualizing and mapping MITRE ATT&CK techniques.                           |
|                       | Analysis           | [caido](https://github.com/caido/caido)                                                     | Analysis tool for security assessments.                                             |
|                       | Phishing           | [gophish](https://github.com/gophish/gophish)                                               | Open-source phishing simulation toolkit.                                            |
|                       | Web Screenshots    | [gowitness](https://github.com/sensepost/gowitness)                                         | Tool for capturing screenshots of web services.                                     |
|                       | CTI                | [opencti](https://github.com/OpenCTI-Platform/docker)                                       | Cyber Threat Intelligence (CTI) platform.                                           |
|                       | Reconnaissance     | [spiderfoot](https://github.com/smicallef/spiderfoot)                                       | Automated OSINT tool for gathering intelligence.                                    |
|                       | Forensics          | [velociraptor](https://github.com/Velocidex/velociraptor)                                   | Endpoint visibility and forensic tool.                                              |
|                       | Web Security       | [web-check](https://github.com/Lissy93/web-check)                                           | Automated web application security scanner.                                         |
| **siem**              |                    |                                                                                             |                                                                                     |
|                       | Threat Detection   | [crowdsec](https://crowdsec.net)                                                            | Collaborative cybersecurity tool for threat detection.                              |
|                       | Analytics          | [grafana](https://grafana.com)                                                              | Open-source platform for monitoring and observability dashboards.                   |
|                       | SIEM               | [graylog](https://github.com/Graylog2/graylog-docker)                                       | Centralized log management and analysis tool.                                       |
|                       | Time-series DB     | [influxdb](https://hub.docker.com/_/influxdb)                                               | High-performance time-series database.                                              |
|                       | Endpoint Security  | [sophos](https://github.com/sophos/Sophos-Central-SIEM-Integration)                         | Advanced endpoint security and management tool.                                     |
|                       | SIEM               | [splunk](https://hub.docker.com/r/splunk/splunk)                                            | Enterprise-level security information and event management tool.                    |
|                       | Monitoring         | [telegraf](https://github.com/influxdata/telegraf)                                          | Metrics collection and reporting agent for InfluxDB.                                |
|                       | Incident Response  | [thehive4](https://github.com/TheHive-Project/Docker-Templates)                             | Enhanced version of TheHive for incident response.                                  |
|                       | SIEM               | [wazuh](https://github.com/wazuh/wazuh-docker)                                              | Open-source security monitoring and compliance tool.                                |
| **sys-admin**         |                    |                                                                                             |                                                                                     |
|                       | Boot Management    | [netboot](https://github.com/netbootxyz/docker-netbootxyz)                                  | PXE boot server for managing network bootable systems.                              |
|                       | IP Management      | [netbox](https://github.com/netbox-community/netbox-docker)                                 | IP address management and data center infrastructure modeling.                      |
|                       | Network Analysis   | [ntopng](https://github.com/ntop/docker-ntop)                                               | High-performance network traffic analysis and monitoring tool.                      |
|                       | Asset Management   | [snipe-it](https://github.com/snipe/snipe-it)                                               | Open-source IT asset management tool.                                               |
| **sys-infra**         |                    |                                                                                             |                                                                                     |
|                       | Diagramming        | [affine](https://github.com/toeverything/AFFiNE)                                            | Vector graphic design and diagramming tool.                                         |
|                       | IDE                | [coder](https://coder.com/docs/install/docker)                                              | Collaborative development environment.                                              |
|                       | File Management    | [filebrowser](https://github.com/filebrowser/filebrowser)                                   | Lightweight file management tool for web servers.                                   |
|                       | Budgeting          | [firefly-iii](https://github.com/firefly-iii/docker)                                        | Personal finance and budgeting manager.                                             |
|                       | Photo Organizer    | [immich](https://github.com/immich-app/immich)                                              | Self-hosted photo and video storage and management.                                 |
|                       | Budgeting          | [InvoiceShelf](https://github.com/InvoiceShelf/docker)                                      | Open-source invoicing software.                                                     |
|                       | Time Tracking      | [kimai](https://github.com/kimai/kimai)                                                     | Time-tracking software for freelancers and teams.                                   |
|                       | Cloud Storage      | [nextcloud](https://github.com/nextcloud/docker)                                            | Open-source file sharing and collaboration platform.                                |
|                       | Cloud Storage      | [nextcloud-aio](https://github.com/nextcloud/all-in-one)                                    | All-in-one Dockerized Nextcloud solution.                                           |
|                       | Project Management | [odoo-project](https://www.odoo.com/app/project)                                            | Odoo app for managing projects and tasks.                                           |
|                       | Project Management | [openproject](https://github.com/opf/openproject-deploy)                                    | Open-source project management software.                                            |
|                       | Cloud Storage      | [owncloud](https://hub.docker.com/r/owncloud/server)                                        | Enterprise file sharing and collaboration platform.                                 |
|                       | PDF Tool           | [stirling-pdf](https://github.com/Stirling-Tools/Stirling-PDF)                              | Tool for PDF document manipulation and editing.                                     |
|                       | File Sync          | [syncthing](https://github.com/syncthing/syncthing)                                         | Continuous file synchronization tool.                                               |
| **sys-security**      |                    |                                                                                             |                                                                                     |
|                       | Password Manager   | [bitwarden](https://github.com/bitwarden/server)                                            | Open-source password management solution.                                           |
|                       | Identity Platform  | [goauthentik](https://github.com/goauthentik/authentik)                                     | Open-source identity and access management system.                                  |
|                       | Password Manager   | [passbolt](https://hub.docker.com/r/passbolt/passbolt)                                      | Team-based password management platform.                                            |
| **sys-tools**         |                    |                                                                                             |                                                                                     |
|                       | Battery Checker    | [akkudoktor](https://github.com/Akkudoktor-EOS/EOS)                                         | Tool for monitoring battery health and performance.                                 |
|                       | Diagramming        | [drawio](https://github.com/jgraph/docker-drawio)                                           | Web-based diagramming tool for creating flowcharts and designs.                     |
|                       | Diagramming        | [excalidraw](https://github.com/excalidraw/excalidraw)                                      | Open-source sketching and diagramming tool.                                         |
|                       | News Aggregator    | [freshrss](https://github.com/FreshRSS/FreshRSS)                                            | Self-hosted RSS feed reader.                                                        |
|                       | Tooling            | [IT-Tools](https://github.com/CorentinTh/it-tools)                                          | Useful tools for developer and people working in IT.                                |
|                       | Speed Testing      | [openspeedtest](https://hub.docker.com/r/openspeedtest)                                     | Self-hosted internet speed testing tool.                                            |
|                       | URL Shortener      | [shlink](https://hub.docker.com/r/shlinkio/shlink)                                          | Self-hosted URL shortener and analytics tool.                                       |
| **TODO**              |                    |                                                                                             |                                                                                     |
|                       | URL Shortener      | [kutt](https://github.com/thedevs-network/kutt)                                             | Modern URL shortener with support for custom domains.                               |
|                       | Static Site Gen    | [quartz](https://github.com/jackyzha0/quartz)                                               | static-site generator, transforms Markdown content into fully functional websites.  |
|                       | Static Site Gen    | [vitepress](https://github.com/vuejs/vitepress)                                             | static site generator.                                                              |
|                       | Static Site Gen    | [pocketbase](https://github.com/pocketbase/pocketbase)                                      | Open Source realtime backend in 1 file                                              |
|                       | VPN                | [algo](https://github.com/trailofbits/algo)                                                 | Set up a personal VPN in the cloud                                                  |
|                       | Email Marketing    | [listmonk](https://listmonk.app)                                                            | High-performance self-hosted newsletter and mailing list manager.                   |
|                       | HRM                | [orangehrm](https://github.com/orangehrm/orangehrm)                                         | .                                                                                   |
|                       | Ticketing System   | [zammad-docker-compose](https://docs.zammad.org/en/latest/install/docker-compose.html)      | Self-hosted ticketing and customer support system.                                  |
|                       | File Management    | [pydio-cells](https://github.com/pydio/cells)                                               | Enterprise file sharing and collaboration platform.                                 |
|                       | Customer Support   | [chatwoot](https://github.com/chatwoot/chatwoot)                                            | Open-source customer support and engagement platform.                               |
|                       | Diagramming        | [penpot](https://help.penpot.app/technical-guide/getting-started/#install-with-docker)      | design & prototype platform that is deployment agnostic.                            |
|                       | Monitoring         | [zabbix-docker](https://github.com/zabbix/zabbix-docker)                                    | Containerized Zabbix for IT infrastructure monitoring.                              |
|                       | Collaboration      | [mattermost](https://github.com/mattermost/mattermost)                                      | Open-source messaging and collaboration platform.                                   |
|                       | Collaboration      | [codimd](https://github.com/hackmdio/codimd)                                                | Open-source real-time collaborative markdown editor.                                |
|                       | Remote Desktop     | [rustdesk-server-oss](https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/docker)    | Open-source remote desktop software with self-hosted server.                        |
|                       | Identity Platform  | [zentyal](https://zentyal.com)                                                              | Join Win-Clients to the domain and manage them transparently.                       |
|                       | Task Management    | [vikunja](https://kolaente.dev/vikunja)                                                     | Open-source project and task management tool.                                       |
|                       | Git Hosting        | [gitea](https://docs.gitea.com/installation/install-with-docker)                            | Lightweight, self-hosted Git service.                                               |
|                       | Budgeting          | [actual-budget](https://github.com/actualbudget/actual)                                     | Open-source personal budgeting software.                                            |
|                       | Monitoring         | [OpenTelemetry](https://opentelemetry.io/docs/demo/docker-deployment/)                      | High-quality, ubiquitous, and portable telemetry to enable effective observability. |
|                       | Reporting          | [BugZilla](https://github.com/bugzilla/bugzilla)                                            | The software solution designed to drive software development                        |
|                       | Testing            | [netpicker](https://github.com/netpicker/netpicker)                                         | Test your network compliance, design and security.                                  |
|                       | Wiki               | [outline](https://github.com/outline/outline)                                               | The fastest knowledge base for growing teams.                                       |
|                       | Wiki               | [wiki.js](https://github.com/requarks/wiki)                                                 | A modern and powerful wiki app built on Node.js                                     |
|                       | VPN                | [WGDashboard](https://github.com/donaldzou/WGDashboard)                                     | Simple dashboard for WireGuard VPN                                                  |
|                       |                    |                                                                                             |                                                                                     |

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
