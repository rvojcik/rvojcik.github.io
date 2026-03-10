---
id: 845
title: How To Build Your NAS
date: 2025-11-06T10:19:21+00:00
author: Robert Vojčík
layout: post
guid: https://www.vojcik.net/?p=845
permalink: /how-to-build-your-nas/
categories:
  - Blog
  - Kernel
  - SysAdmin
  - Linux
---
Building your own network storage (NAS) doesn’t have to be expensive or complicated. Today, we’ll take a look at how to approach designing your own NAS case and also how to migrate data from the original storage to the new solution.

![img1](/img/blog/nas/nas-thumb.jpg)

<!--more-->

I have wrote whole series on [root.cz](https://www.root.cz/serialy/stavime-vlastni-nas/) online magazine.

* [S1: HW and Operating System](/building-your-nas-hardware-and-os/) - [Czech version](https://www.root.cz/clanky/stavime-vlastni-nas-vyber-hardwaru-a-volba-operacniho-systemu/)
* [S2: Custom Case & Data Migration](/building-your-nas-case-and-migration/) - [Czech version](https://www.root.cz/clanky/stavime-vlastni-nas-vyroba-skrine-a-migrace-dat-na-uloziste/)
* [S3: Configuration of services](/building-your-nas-services/) - [Czech version](https://www.root.cz/clanky/stavime-vlastni-nas-konfigurace-sluzeb-na-sitovem-ulozisti/)
* [S4: NAS monitoring](/building-your-nas-monitoring/) - [Czech version](https://www.root.cz/clanky/stavime-vlastni-nas-monitoring-naseho-sitoveho-uloziste/)
* [S5: NAS Basic Security & Firewall](/building-your-nas-security/) - [Czech version](https://www.root.cz/clanky/stavime-vlastni-nas-bezpecnost-ochrana-a-firewall/)

---

## Build Gallery

### Hardware

{% include gallery.html gallery="nas-hardware"
  images="/img/diy-nas/board1.jpg|PcZinophyte 6-Bay NAS motherboard,
          /img/diy-nas/boards_form_factor.jpg|Motherboard form factor comparison,
          /img/diy-nas/m2sata.jpg|M.2 SATA SSDs used for the system,
          /img/diy-nas/power1.jpg|External 12V power adapter and Mini ATX PSU,
          /img/diy-nas/cable_5bay.jpg|5-bay SATA power splitter cable,
          /img/diy-nas/install1.jpg|Ubuntu Server installation" %}

### Prototype and Enclosure Design

{% include gallery.html gallery="nas-enclosure"
  images="/img/diy-nas/beta1.jpg|First prototype — hardware testing and data migration,
          /img/diy-nas/naked.jpg|NAS enclosure — bare frame,
          /img/diy-nas/clean.jpg|NAS enclosure — clean assembled,
          /img/diy-nas/tuned.jpg|NAS enclosure — final tuned design" %}

### Build Process

{% include gallery.html gallery="nas-build"
  images="/img/diy-nas/gallery/PXL_20250601_195916615.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250608_170609976.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250608_170621095.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250609_164130262.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250609_211147671.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250613_132228405.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250613_132245978.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250613_132325950.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250614_061156602.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250614_061214398.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250615_102628041.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250624_163110850.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250624_163248634.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250624_164831226.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250624_165657037.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250624_165909749.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250624_170011293.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250624_171302047.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250624_171846667.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250624_172311734.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250624_172500759.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250628_150028352.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250629_081800868.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250629_082547254.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250629_082725638.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250629_082931831.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250629_083155728.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250629_083249126.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250629_083409673.jpg|Build process,
          /img/diy-nas/gallery/PXL_20250629_084313989.jpg|Finished NAS build,
          /img/diy-nas/gallery/PXL_20250629_084614590.jpg|Finished NAS build,
          /img/diy-nas/gallery/PXL_20250629_085241654.jpg|Finished NAS build" %}

### Monitoring and Services

{% include gallery.html gallery="nas-software"
  images="/img/diy-nas/monitoring.png|Monitoring stack overview,
          /img/diy-nas/grafana.png|Grafana dashboard showing NAS metrics,
          /img/diy-nas/nas-temperatures.png|Component temperatures,
          /img/diy-nas/nas-power-hdd-states.png|Disk power state and standby transitions,
          /img/diy-nas/owncloud-admin-external_storage.png|ownCloud admin — enabling External Storage,
          /img/diy-nas/owncloud-external-storage.png|ownCloud — user configuring external Samba share,
          /img/diy-nas/owncloud-user.png|ownCloud — user view with mounted storage,
          /img/diy-nas/gmail_pass.png|Creating a Google App Password for Postfix" %}
