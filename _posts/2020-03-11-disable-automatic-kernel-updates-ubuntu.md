---
id: 844
title: How To Disable Automatic Kernel Updates on Ubuntu like systems
date: 2020-03-10T10:19:21+00:00
author: Robert Vojčík
layout: post
guid: https://www.vojcik.net/?p=844
permalink: /hot-to-disable-automatic-kernel-updates-ubuntu/
categories:
  - Blog
  - Kernel
  - SysAdmin
  - Linux
---

First of all, I don't recommend disabling Automatic Updates in general.
It's important to have system up to date, applications and kernel.

But there are several reasons why you might want to update your Kernel 
by hand, in time when you are ready to deal with problems. One most common 
reasons are performance graphics cards. It depends on manufacturer and model 
but sometimes it's not very easy and stable to build graphics drivers, 
even when you are using DKMS.

If your computer is a tool for your job it's very annoying to come to your PC in
the morning and find it broken. You have to spent lot of time to fix it and it
happends always when you don't have time for this.

<!--more-->

## How ubuntu updating kernel ?

You probably already know, that there is unattended upgrade. Unattended upgrades
check for new version of packages but, kernel packages don't have never versions.
Every kernel has package with version in name of the package like
<pre>
ii  linux-image-4.15.0-88-generic
ii  linux-image-4.15.0-91-generic
</pre>

There is another 2 packages which describe actual kernel version in the system.
<pre>
linux-image
linux-image-generic
</pre>


## Disable kernel automatic update

If you want to disable automatic upgrades of the kernel, just uninstall these two packages.
<pre>
apt-get remove linux-image linux-image-generic
</pre>

It's not kernel itself, just packages which describe which kernel package should be installed
on the system.

# Manual kernel upgrade

If you are in situation where you have to disable automatic kernel upgrade, upgrade it manualy once a week or month.

Simply install again 
<pre>
apt-get update && apt-get install -y linux-image-generic
</pre>

After this operation, if everything works you now should again uninstall linux-image-generic to disable auto upgrade.

