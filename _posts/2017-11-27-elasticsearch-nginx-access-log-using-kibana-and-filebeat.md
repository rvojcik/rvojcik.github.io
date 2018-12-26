---
id: 840
title: Elasticsearch + Nginx Access Log using Kibana and FileBeat
date: 2017-11-27T17:35:43+00:00
author: Robert Vojčík
layout: post
guid: https://www.vojcik.net/?p=840
permalink: /elasticsearch-nginx-access-log-using-kibana-and-filebeat/
categories:
  - Blog
  - HowTos
  - Linux
  - SysAdmin
tags:
  - accesslog
  - elasticsearch
  - elk
  - filebeat
  - kibana
  - nginx
  - web
  - webserver
---
Long time no see. Very short post today, very fast howto to implement access log logging to elasticsearch using simple utilities.

First of all, I expect you have already setup your elastic cluster with Kibana or Grafana or whatever.

<!--more-->

First of all, let&#8217;s begin with **Nginx** itself.

Create file /etc/nginx/conf.d/json_log.conf with this content:

```
log_format json_combined escape=json '{ "timestamp": "$time_iso8601", '
 '"remote_addr": "$remote_addr", '
 '"remote_user": "$remote_user", '
 '"request_url": "$request_uri", '
 '"req_status": "$status", '
 '"response_size_B": "$bytes_sent", '
 '"req_protocol": "$server_protocol",'
 '"req_method": "$request_method",'
 '"req_srvname": "$server_name",'
 '"req_time": "$request_time",'
 '"connection-id": "$request_id",'
 '"ssl_prot_version": "$ssl_protocol",'
 '"ssl_cipher": "$ssl_cipher",'
 '"ssl_conn_reused": "$ssl_session_reused",'
 '"ssl_session_id": "$ssl_session_id",'
 '"http_referrer": "$http_referer", '
 '"http_user_agent": "$http_user_agent", '
 '"http_x_referer": "$http_x_referer" }';


access_log /var/log/nginx/access_json.log json_combined;

```

This will create new access log in JSON format defined above.

Time to restart nginx and check the file

If you see something like this, you are ready for next step

`{ "timestamp": "2017-11-27T17:28:47+01:00", "remote_addr": "5.164.120.117", "remote_user": "", "request_url": ...blablabla }`

Now go to <a href="https://www.elastic.co/products/beats/filebeat" target="_blank" rel="noopener">Elastic.co FileBeat page</a> and install filebeat to your server.

After installing edit file /etc/filebeat/filebeat.yml

```
filebeat.prospectors:

- input_type: log

  # Paths that should be crawled and fetched. Glob based paths.
  paths:
    - /var/log/nginx/access_json.log
  json.message_key: remote_addr
  json.keys_under_root: true

tags: ["whateveryouwant"]
max_procs: 3

#-------------------------- Elasticsearch output ------------------------------
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["your.elasticsearch.server:9200"]

  # Optional protocol and basic auth credentials.
  #protocol: "https"
  #username: "elastic"
  #password: "changeme"
  bulk_max_size: 2000
```


**Now restart filebeat and you&#8217;re DONE!**

