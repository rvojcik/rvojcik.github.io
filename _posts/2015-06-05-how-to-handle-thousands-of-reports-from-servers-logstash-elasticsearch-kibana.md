---
id: 764
title: 'How to handle thousands of reports from servers &#8211; Logstash, ElasticSearch, Kibana'
date: 2015-06-05T17:29:31+00:00
author: Robert Vojčík
layout: post
guid: http://www.vojcik.net/?p=764
permalink: /how-to-handle-thousands-of-reports-from-servers-logstash-elasticsearch-kibana/
categories:
  - Blog
  - HowTos
  - Linux
  - Networking
  - SysAdmin
---
Many services and server audit utilities like logcheck, logwatch, cron daemon, aide, ZRM, etc. are sending emails to local user or root. Some of them, can be easily configured but some of them not.

Best way in my case is to deal with emails directly, but how ?

<!--more-->

### All localhost mails from all servers to one mailbox

First of all, there are several problems you have to deal with.  First is to get all localhost emails from all servers to one mailbox. I&#8217;m using postfix on all servers, so I have to do some small configuration change on all servers.

#### On all servers

/etc/postfix/main.cf

```
...
local_transport = smtp:[your.mailserver.host]
...
```


This option forward all emails, which are designated to be delivered to localhost to mailserver **your.mailserver.host**

Now you had all this emails on your central mailserver, no matter who or what sends them.

On your central mailserver (**your.mailserver.host**) you have to deal with this mails somehow. Here is very important to have something which all this emails have in common. In my case all servers have same domain name and it&#8217;s **management.intra**. So for example if I had email from cron daemon from user root on server database1, email have in TO header address **root@database1.management.intra**.

I create small configuration to dealing with this emails and forward them to one mailbox called **reports@domain.tld**.

#### On central mailserver

/etc/postfix/header_checks

`/To: .*@.*\.management\.intra/  REDIRECT    reports@domain.tld`

/etc/postfix/main.cf

```
...
# Check headers
header_checks = regexp:/etc/postfix/header_checks
...
```

Now all emails which going to **\*@\*.management.intra** will be stored in **reports@domain.tld** mailbox hosted on your central mailserver.

### Retrieve, parse and store mails

For this we have amazing tool called [Logstash](https://www.elastic.co/products/logstash). It helps you process, parse, analyze and store data from inputs to outputs. Logstash have various plugins and options how to deal with data. You can use multiple different inputs and outputs based on your needs.

I&#8217;m using imap as input and [ElasticSearch](https://www.elastic.co/products/elasticsearch) as database backend (output).

Why elasticsearch ?

  * easy to configure
  * HA ready
  * easy to scale
  * full-text search
  * schema free
  * [Kibana4](https://www.elastic.co/products/kibana) interface for data analyzing and vizualization

I show you only important basics. You don&#8217;t find here how to install and operate ElasticSearch and Logstash. This information is available in their documentation and on the website.

#### Logstash configuration

Input configuration

```
input {
    imap {
        host =&gt; "your.mailserver.host"
        user =&gt; "reports@domain.tld"
        password =&gt; "StrongPasswordAsHell"
        verify_cert =&gt; false
        fetch_count =&gt; 1000
    }
}
```

Filter configuration

This is very simple example of real file.

I have dozens of report services and stuff, most of them are very specific, not opensource so I decided to show only few which are well known and opensource.

```
filter {
###
### Check message based on FROM part
###

    ##
    ## Remove some field
    ##
    mutate {
        remove_field =&gt; [ "received", "x-virus-scanned", "message-id", "received", "x-spam-flag", "x-spam-score", "x-spam-level", "x-spam-status", "content-type", "x-cron-env" ]
    }

    ##
    ## KEEPALIVED
    ##
    if [from] =~ "^keepalived@.*" {
        mutate { add_tag =&gt; "keepalived" }
        if [subject] =~ ".*UP" {
            mutate { add_field =&gt; { "message_status" =&gt; "OK" } }
        }
        else {
            mutate { add_field =&gt; { "message_status" =&gt; "ERROR" } }
        }
    }

    ##
    ## LOGCHECK
    ##
    else if [from] =~ ".*logcheck@.*" {
        mutate { add_tag =&gt; "logcheck" }

        # If logcheck report is from reboot, tag it
        if "Reboot:" in [subject] {
            mutate { add_tag =&gt; "reboot" }
        }

        # Split message field into separate events
        split {}

        # Parse message for logcheck and rewrite original message
        grok {
            match =&gt; ["message", "%{SYSLOGBASE} %{GREEDYDATA:message}"]
            overwrite =&gt; ["message"]
        }

        # Replace @timestamp of record with time translated from syslog line
        date {
            match =&gt; [ "timestamp", "MMM dd HH:mm:ss", "MMM  d HH:mm:ss", "MMM dd YYY HH:mm:ss", "MMM  d YYY HH:mm:ss", "ISO8601" ]
        }
    }

    ##
    ## NAGIOS
    ##
    else if [from] =~ "^nagios@.*" {
        mutate { add_tag =&gt; "nagios" }
        if [message] =~ ".*(OK|UP).*" {
            mutate { add_field =&gt; { "message_status" =&gt; "OK" } }
        }
        else if [message] =~ ".*WARNING" {
            mutate { add_field =&gt; { "message_status" =&gt; "WARNING" } }
        }
        else {
            mutate { add_field =&gt; { "message_status" =&gt; "ERROR" } }
        }
    }

    ##
    ## ZRM
    ##
    else if "/usr/bin/zrm-pre-scheduler" in [subject] {
        mutate { add_tag =&gt; "zrm" }
        if [message] =~ ".* WARNING: " {
             mutate { add_field =&gt; { "message_status" =&gt; "WARNING" } }
        }
        else if [message] =~ ".*backup-status=Backup succeeded" {
            mutate { add_field =&gt; { "message_status" =&gt; "OK" } }
        }
        else {
            mutate { add_field =&gt; { "message_status" =&gt; "ERROR" } }
        }
    }
    ##
    ## OTHERS
    ##
    else if "Cron" in [subject] {
        mutate { add_tag =&gt; "cron" }
    }
    ##
    ## OTHERS
    ##
    else {
        mutate { add_tag =&gt; "others" }
    }

    ##
    ## Drop everything that fails grok
    ##
    if "_grokparsefailure" in [tags] {
        drop{}
    }
}
```

Output configuration

```
output{
    elasticsearch {
        host =&gt; "127.0.0.1"
        cluster =&gt; "elasticsearch"
        index =&gt; "reports-%{+YYYY.MM.dd}"
        template =&gt; "/etc/logstash/elasticsearch-template.json"
    }
}
```

/etc/logstash/elasticsearch-template.json

```
{
  "template" : "reports-*",
  "settings" : {
    "index.refresh_interval" : "5s"
  },
  "mappings" : {
    "_default_" : {
       "_all" : {"enabled" : true},
       "dynamic_templates" : [ {
         "string_fields" : {
           "match" : "*",
           "match_mapping_type" : "string",
           "mapping" : {
             "type" : "string", "index" : "analyzed", "omit_norms" : true,
               "fields" : {
                 "raw" : {"type": "string", "index" : "not_analyzed", "ignore_above" : 256}
               }
           }
         }
       } ],
       "properties" : {
         "@version": { "type": "string", "index": "not_analyzed" },
         "geoip"  : {
           "type" : "object",
             "dynamic": true,
             "path": "full",
             "properties" : {
               "location" : { "type" : "geo_point" }
             }
         }
       }
    }
  }
}
```

This json file create from every field it&#8217;s not_analyzed version with .raw suffix. It&#8217;s handy later when you do some analysis on data.

#### Kibana4

From this point you have realtime data from your imap in your elasticsearch database, and you are able to analyze them.

I mentioned [Kibana4](https://www.elastic.co/products/kibana) earlier. It&#8217;s very powerfull tool for analyzing date. For example here are some screenshots

Discover data &#8211; Cron messages

![img1](/wp-content/uploads/2015/06/dashboard-discover-cron.png)

Dashboard

![img2](http://www.vojcik.net/wp-content/uploads/2015/06/dashboard1.png)

&nbsp;

**Custom tools**

Now you have your data standardized in ElasticSearch database and you can have really big fun with them.

Based on your team goals and your role you can create your own tools suited to your needs. You can visualize, analyze, search and discover your data from one interface.

In next two screenshots you can see small example of our custom tool which use ElasticSearch as backend along with Kibana4. It gives sense to data, you can see results from thousands reports in second and it helps us to run our big infrastructure 24/7/365 with 99,99 % availability, fixed problems quickly and prevent them to happen.

<span style="color: #ff0000;"><strong>You have to know, what is happening in your infrastructure because hope is not  a strategy.</strong></span>

SQL backups (hundreds of backups)

![img3](http://www.vojcik.net/wp-content/uploads/2015/06/logcheck-dbb.png)

Cron messages

![img4](http://www.vojcik.net/wp-content/uploads/2015/06/logcheck-cron.png)
