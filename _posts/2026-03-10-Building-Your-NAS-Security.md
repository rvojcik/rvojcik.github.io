---
title: "Building Your Own NAS: Security, Protection and Firewall"
date: 2026-03-10T00:00:00+00:00
author: Robert Vojčík
layout: post
permalink: /building-your-nas-security/
categories:
  - Blog
  - SysAdmin
  - Linux
  - NAS
  - Security
---

<img src="/img/diy-nas/thumb-s5-security.jpg" alt="Finished NAS build" style="float:right;margin:0 0 1em 1.5em;max-width:200px">

The final chapter of the NAS series covers practical security measures: automatic updates, SSH hardening, UFW firewall, and Fail2Ban intrusion prevention. Plus a full retrospective on the project with real performance numbers and cost breakdown.

<!--more-->

> This is part 5 of the "Building Your Own NAS" series, originally published on [root.cz](https://www.root.cz/serialy/stavime-vlastni-nas/).
> [S1: Hardware & OS](/building-your-nas-hardware-and-os/) · [S2: Custom Case & Data Migration](/building-your-nas-case-and-migration/) · [S3: Service Configuration](/building-your-nas-services/) · [S4: Monitoring](/building-your-nas-monitoring/) · [S5: Security & Firewall](#)

---

## Automatic Updates

To keep the NAS current without managing security updates manually, use Ubuntu Server's Unattended Upgrades:

```bash
apt install -y unattended-upgrades
```

By default, upgrades run daily at 6:00 AM ± 1 hour. Verify with:

```bash
systemctl cat apt-daily-upgrade.timer
```

To run upgrades at 4:00 AM precisely:

```bash
systemctl edit apt-daily-upgrade.timer
```

Add:
```ini
[Timer]
OnCalendar=*-*-* 4:00
Persistent=true
RandomizedDelaySec=0
```

Using `OnCalendar`, you can achieve various schedules — every Monday, first of the month, first Friday of the month, etc.

Review `/etc/apt/apt.conf.d/50unattended-upgrades` to control what gets upgraded automatically. You can permit automatic reboots and filter by package source or name.

---

## File Services

Consider your access method — Samba, NFS, WebDAV, FTP, or another. If accessing directly from the internet, use TLS implementations.

Check guest/anonymous modes carefully. Some services support these by default — verify that unauthorized access cannot occur.

---

## SSH Server

Your main access point for NAS administration. Ubuntu Server provides a reasonable baseline in `/etc/ssh/sshd_config`, but a few settings deserve attention:

**`PermitRootLogin prohibit-password`**
Root login requires non-password authentication (SSH keys). Consider switching to `no` and using `sudo` instead:
```
PermitRootLogin no
```

**`AllowUsers youruser`**
If you create system users for Samba or other services, control SSH access explicitly. Only allow management users:
```
AllowUsers youruser
```
You can also restrict by source network: `AllowUsers youruser@192.168.1.*`

**`PasswordAuthentication no`**
If the NAS is internet-accessible, disable password login completely. Keys only:
```
PasswordAuthentication no
```

**Idle session timeout:**
```
ClientAliveInterval 300
ClientAliveCountMax 0
```
Automatically terminates inactive connections after 5 minutes.

---

## UFW — Uncomplicated Firewall

Simple and sufficient for most home/small-office NAS deployments:

```bash
# Install
apt install ufw

# Allow needed services
ufw allow "Nginx Full"
ufw allow OpenSSH
ufw allow Samba

# Enable
ufw enable

# Check status
ufw status

# List available predefined applications
ufw app list
```

For complex requirements (stateful rules, advanced NAT, etc.), consider `nftables`, `FirewallD`, or `Shorewall` instead.

---

## Fail2Ban

Excellent for any internet-accessible server. Fail2Ban monitors logs and automatically blocks IP addresses after repeated failed login attempts. Particularly valuable for SSH, but protects many applications. Custom rules can extend coverage beyond standard repositories.

```bash
apt install fail2ban
```

Configuration lives in `/etc/fail2ban/`:

| Path | Purpose |
|---|---|
| `action.d/` | Available action definitions (what happens when a ban triggers) |
| `fail2ban.conf` | Main config file — usually no changes needed |
| `fail2ban.d/` | Custom overrides for the main config |
| `jail.d/` | Jail-specific monitoring settings — add your rules here |

### SSH Protection

Create `/etc/fail2ban/jail.d/nas.conf`:

```ini
[DEFAULT]
banaction = ufw
application = OpenSSH
backend = systemd

[sshd]
enabled = true
```

Config details:
- `banaction = ufw` — use UFW to apply bans
- `application = OpenSSH` — tells UFW the correct application name for rule creation
- `backend = systemd` — read logs from systemd journal

Test by attempting failed logins from another machine and watching the log:

```bash
tail -f /var/log/fail2ban.log
```

Expected output after enough failures:
```
2025-07-16 14:19:06,969 fail2ban.actions [2232402]: NOTICE [sshd] Ban 147.32.xx.xx
```

Verify the UFW rule was created:
```bash
ufw status
# To                         Action      From
# --                         ------      ----
# Anywhere                   REJECT      147.32.xx.xx  # by Fail2Ban after 5 attempts
```

Unban when needed:
```bash
fail2ban-client unban 147.32.xx.xx
```

### Fail2Ban — ownCloud Protection

Create a custom filter in `/etc/fail2ban/filter.d/owncloud.conf`:

```ini
[Definition]
failregex=.*Login failed: \'.*\' \(Remote IP: \'\'\).*
ignoreregex =
```

Add the jail in `/etc/fail2ban/jail.d/nas.conf`:

```ini
[owncloud]
banaction = ufw[kill-mode="ss", blocktype="deny"]
enabled = true
filter = owncloud
maxretry = 5
logpath = /var/lib/containers-data/owncloud/server/files/owncloud.log
backend = auto
```

Config details:
- `banaction = ufw[kill-mode="ss", blocktype="deny"]` — use UFW, terminate all existing connections from the banned IP, block with DENY
- `maxretry = 5` — number of failures before blocking
- `logpath` — path to the ownCloud log file
- `backend = auto` — file-based log watching

Restart after changes:
```bash
systemctl restart fail2ban.service
```

---

## Project Retrospective

The build succeeded, meeting all requirements. Hardware quality and longevity remain to be proven over time, but no issues encountered so far.

The NAS is quiet — barely audible. This depends mainly on the disks and fans selected. Stability was tested with `fio` and `CPU Burn` utilities; during full data migration performance remained stable throughout.

### Operating Data

| Metric | Value |
|---|---|
| Power — maximum load (stress test) | 85 W |
| Power — normal NAS operation | 40 W |
| Power — disk standby (most of the time) | 18 W |
| Storage access per day | ~2.5 hours (90% of time in standby) |
| Disk temperature — migration/testing | 41°C |
| Disk temperature — standard operation | 34°C |
| Samba transfer — local gigabit network | ~124 MB/s |
| Samba transfer — internet via WireGuard | ~90 MB/s |

### Project Costs

| Item | Cost (CZK) |
|---|---|
| Motherboard (PcZinophyte 6-Bay NAS) | 3,070 |
| 16 GB RAM | 900 |
| Mini ATX PSU | 300 |
| Power/reset buttons | 240 |
| SATA data and power cables | 300 |
| 12 cm fan | 120 |
| ASA filament (3D printed parts) | 117 |
| PLA filament | 15 |
| PETG filament | 340 |
| **Total** | **~5,402 CZK** |

### Time Investment

| Task | Time |
|---|---|
| Board testing | 2 hours |
| 3D modeling | 9 hours |
| System installation | 1 hour |
| Configuration, migration, service deployment | 6 hours |
| Performance testing | 2 hours |
| **Total** | **~20 hours** |

---

## Why Undertake Such a Project?

You learn considerably — especially when you have available time and want to build practical skills. You gain knowledge, capability, and confidence for both small and large endeavors. Building and configuring your own system means encountering real problems whose solutions teach patience, independence, and logical thinking.

You develop problem-solving speed and efficiency in situations where standard approaches don't match your requirements. You recognize that you can solve numerous things yourself — perhaps imperfectly, but adequately.

---

## Sources

- All configuration files: [github.com/rvojcik/nas-diy-resources](https://github.com/rvojcik/nas-diy-resources)
- 3D NAS model: [Printables.com](https://www.printables.com/model/1354721-nas-storage)
