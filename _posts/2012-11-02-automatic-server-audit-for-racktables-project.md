---
id: 528
title: Automatic server audit for RackTables project
date: 2012-11-02T22:53:46+00:00
author: Robert Vojčík
layout: post
guid: /?p=528
permalink: /automatic-server-audit-for-racktables-project/
categories:
  - Blog
  - Linux
  - Python
---
First I&#8217;d like to introduce one very nice project called <a title="RackTables" href="http://www.racktables.org" target="_blank">RackTables</a>. It&#8217;s management system for DataCenters or rack rooms. I test many project like this but this one fits best for our needs. With this system you can document your network and infrastructure. Datacenters, rooms, rack rows, servers and their attributes, ipv4/ipv6 ranges, virtual resources, etc.

I work as System Specialist, many times it&#8217;s too much work and I forgot to document some changes which I made on server or infrastructure. When number of servers grows to hundreds this is a really big problem you must handle. Important is also to know, what was the change, not only actual state. So you must create log of changes.

I have created one small script which discover physical or virtual server and insert or update information into racktables database and ! it create LOG in RackTables. You see what was the previous state and when this change was made.

Script can handle various system and HW infromation and what is perfect, it do it automatically without any interaction.

<!--more-->

I show you some examples what this system can do for you.

## Create new object based on hostname and Service-TAG

This is one of core features. When you run this application on server, it first check hostname and Service-TAG (ST) and compare with database. If this combination not exist, it create new server object.

It recognize physical and virtual servers, virtual servers have automatically generated ST as &#8220;VPS-hostname&#8221;. It also recognize if server is hypervisor or not and build your virtual resources in database.

[<img class="aligncenter size-thumbnail wp-image-530" title="objects" alt="" src="/wp-content/uploads/2012/11/objects-150x150.png" width="150" height="150" />](/wp-content/uploads/2012/11/objects.png)

On the next picture you should see information collected from server like

  * hostname
  * service\_tag , filled as asset\_tag
  * support type
  * Server model
  * support ends
  * Operating System
  * Interfaces and connections with switches
  * IP addresse, networks and VLANs

All of these information ware collected automaticly.

[<img class="aligncenter size-medium wp-image-531" title="object_detail" alt="" src="/wp-content/uploads/2012/11/object_detail-234x300.png" width="234" height="300" />](/wp-content/uploads/2012/11/object_detail.png)

On the next example is server which was recognized as XEN Hypervisor, it detects virtual servers and linked them with virtual objects.

[<img class="aligncenter size-medium wp-image-532" title="hypervisor_detail" alt="" src="/wp-content/uploads/2012/11/hypervisor_detail-254x300.png" width="254" height="300" />](/wp-content/uploads/2012/11/hypervisor_detail.png)

<p style="text-align: center;">
  Virtual resources overview
</p>

[<img class="aligncenter size-medium wp-image-533" title="virtual_resources" alt="" src="/wp-content/uploads/2012/11/virtual_resources-238x300.png" width="238" height="300" />](/wp-content/uploads/2012/11/virtual_resources.png)

<p style="text-align: center;">
  Warranty and support expiration report
</p>

[<img class="aligncenter size-medium wp-image-534" title="waranty_report" alt="" src="/wp-content/uploads/2012/11/waranty_report-300x204.png" width="300" height="204" />](/wp-content/uploads/2012/11/waranty_report.png)

<p style="text-align: center;">
  Changes are written into log to specific object
</p>

<p style="text-align: center;">
  <a href="/wp-content/uploads/2012/11/log.png"><img class="aligncenter size-medium wp-image-535" title="log" alt="" src="/wp-content/uploads/2012/11/log-300x166.png" width="300" height="166" /></a>Finally look on detail of core switch and it&#8217;s details
</p>

[<img class="aligncenter size-medium wp-image-536" title="switch_links" alt="" src="/wp-content/uploads/2012/11/switch_links-214x300.png" width="214" height="300" />](/wp-content/uploads/2012/11/switch_links.png)

Application was released under GPLv2 license.

<span style="color: #ff0000;">UPDATE</span>

System supports transport of racktables comments to server message of the day file.

When connect to server some useful comment is there for you. It&#8217;s possible edit this comment directly from server by using comment-edit.py utility.

<p style="text-align: center;">
  <a href="/wp-content/uploads/2012/11/comment.png"><img class="aligncenter size-medium wp-image-555" title="comment" alt="" src="/wp-content/uploads/2012/11/comment-300x122.png" width="300" height="122" /></a>
</p>

[<img class="aligncenter size-medium wp-image-556" title="comment-motd" alt="" src="/wp-content/uploads/2012/11/comment-motd-300x164.png" width="300" height="164" />](/wp-content/uploads/2012/11/comment-motd.png)

Links

  * [https://github.com/rvojcik/rt-server-client](https://github.com/rvojcik/rt-server-client "RT-server-client")
