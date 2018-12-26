---
id: 738
title: 'Samsung SSD 840 PRO &#8211; performance degradation'
date: 2014-12-03T14:59:11+00:00
author: Robert Vojčík
layout: post
guid: http://www.vojcik.net/?p=738
permalink: /samsung-ssd-840-pro-performance-degradation/
categories:
  - Blog
  - Hardware
  - Linux
  - SysAdmin
---
About year ago I wrote blogpost about [endurance and performance test of Samsung SSD 840 PRO](http://www.vojcik.net/samsung-ssd-840-endurance-destruct-test/ "Samsung SSD 840: Endurance Destruct Test"). Some things has changed, especially firmware of disks.

I performed test on disk with firmware **DXM04B0Q**. When you want to buy this disk now you probably have firmware **DXM05B0Q** or **DXM06B0Q**.

Problem is, both new firmwares has the same performance degradation issue.

Since my first blogpost we bought about 100 disks and after few months we&#8217;re started observing some problems on database servers. Servers and disks was very slow, we are talking about 10 MB/s continuous write speed.

First of all, we repeat our direct disk test, then we started to test disk with different filesystems.

![img1](/wp-content/uploads/2014/12/samsung-fs-vs-direct-300x148.png)

<!--more-->

As you can see on the graph, direct disk test was ok but situation changed rapidly when you create filesystem and start using disk.

So we created filesystem and did some write tests on **10GB file**.

[<img class="alignnone size-full wp-image-737" src="/wp-content/uploads/2014/12/samsung-fs-degradation.png" alt="samsung-fs-degradation" width="606" height="292" srcset="/wp-content/uploads/2014/12/samsung-fs-degradation.png 606w, /wp-content/uploads/2014/12/samsung-fs-degradation-300x144.png 300w" sizes="(max-width: 606px) 100vw, 606px" />](/wp-content/uploads/2014/12/samsung-fs-degradation.png)

Interesting graph, isn&#8217;t it ?

Especially par of big degradation on the begening every Ext4 test. When we stopped the previous test and format disk to Ext4, we saw bigger performance degradation for some time&#8230; (until disk was rewritten once..) and after it, speed explode to the maximum and stay.

I was thinking that something is wrong with our tests or server or something. So we bought **Intel DC 3700 SSD** and did the same tests.

[<img class="alignnone size-full wp-image-741" src="/wp-content/uploads/2014/12/intel-dc-3700-ssd1.png" alt="intel-dc-3700-ssd" width="609" height="267" srcset="/wp-content/uploads/2014/12/intel-dc-3700-ssd1.png 609w, /wp-content/uploads/2014/12/intel-dc-3700-ssd1-300x131.png 300w" sizes="(max-width: 609px) 100vw, 609px" />](/wp-content/uploads/2014/12/intel-dc-3700-ssd1.png)

As you can see, same tests but no interesting performance changes.


So be aware which firmware you have and don&#8217;t upgrade it if you haven&#8217;t any problems. If you are experiencing some of these issues, try to use **Ext4** filesystem, it may help BUT, remember &#8211; Fill disk once on Ext4 before you start using it.


Note: If you are using LVM (Logical Volume Manager, or simmiliard technology) on your server, Ext4 filesystem probably will **not** help you.
