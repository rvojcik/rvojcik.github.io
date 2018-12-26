---
id: 619
title: HowTo use Grub rescue mode
date: 2013-06-07T22:29:11+00:00
author: Robert Vojčík
layout: post
guid: http://www.vojcik.net/?p=619
permalink: /howto-use-grub-rescue-mode/
categories:
  - Blog
  - HowTos
  - Kernel
  - Linux
  - SysAdmin
---
Sometimes when you upgrade or migrate your linux from one disk to another, boot should hang out on line  &#8220;_**grub rescue>**_&#8220;,

what now ?

<!--more-->

List available disks

<pre class="brush:plain">grub rescue&gt;ls</pre>

Here you can see something like (hd0,msdos1) (hd0,msdos2). Your physical disk is hd0 and partitions are msdos*.
  
Now you must find which is root partition.

<pre class="brush:plain">grub rescue&gt;ls (hd0,msdos1)/
bin   cdrom  etc   initrd.img      lib    lib64       media  opt   root  sbin     srv  tmp  var      vmlinuz.old
boot  dev    home  initrd.img.old  lib32  lost+found  mnt    proc  run   selinux  sys  usr  vmlinuz</pre>

Good this is our root partition. Now we must set prefix for grub to be able load modules and set root to be able load kernel.

<pre class="brush:plain">grub rescue&gt;set prefix=(hd0,msdos1)/boot/grub
grub rescue&gt;insmod linux
grub rescue&gt;set root=(hd0,msdos1)</pre>

Our kernel is located in /vmlinuz and initrd file is /initrd.img (look on ls section)
  
We load kernel and initrd image and boot system.

<pre class="brush:plain">grub rescue&gt;linux /vmlinuz root=/dev/sda1 ro
grub rescue&gt;inird /initrd.img
grub rescue&gt;boot</pre>

Done ! Some lines can be different, it depends on your configuration.

If you are using LVM, or Linux MD RAID you must load additional modules to work with this technologies.

I recomend study your /boot/grub/grub.cfg to learn what your system needs.