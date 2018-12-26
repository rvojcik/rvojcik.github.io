---
id: 834
title: Rsyslog + Elasticsearch/Redis backend template
date: 2016-09-19T14:47:37+00:00
author: Robert Vojčík
layout: post
guid: http://www.vojcik.net/?p=834
permalink: /rsyslog-elasticsearchredis-backend-template/
categories:
  - Blog
  - HowTos
  - Linux
  - SysAdmin
---
Here is example of template when using redis or [Elasticsearch](https://www.elastic.co/products/elasticsearch) backend for [rsyslog](http://www.rsyslog.com/). Very usefull along with [logstash](https://www.elastic.co/products/logstash) and kibana.

```
module(load="omhiredis")
template(name="ls_json" type="list" option.json="on")
   { constant(value="{")
     constant(value="\"timestamp\":\"")         property(name="timegenerated" dateFormat="rfc3339")
     constant(value="\",\"message\":\"")         property(name="msg")
     constant(value="\",\"host\":\"")            property(name="fromhost")
     constant(value="\",\"host_ip\":\"")         property(name="fromhost-ip")
     constant(value="\",\"logsource\":\"")       property(name="fromhost")
     constant(value="\",\"severity_label\":\"")  property(name="syslogseverity-text")
     constant(value="\",\"severity\":\"")        property(name="syslogseverity")
     constant(value="\",\"facility_label\":\"")  property(name="syslogfacility-text")
     constant(value="\",\"facility\":\"")        property(name="syslogfacility")
     constant(value="\",\"program\":\"")         property(name="programname")
     constant(value="\",\"pid\":\"")             property(name="procid")
     constant(value="\",\"syslogtag\":\"")       property(name="syslogtag")
     constant(value="\"}\n")
   } 
*.* action(
  name="push_redis"
  type="omhiredis"
  server="127.0.0.1"
  mode="queue"
  key="syslog"
  template="ls_json"
)

```
