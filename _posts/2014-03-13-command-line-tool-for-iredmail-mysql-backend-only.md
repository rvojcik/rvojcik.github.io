---
id: 719
title: Command Line Tool for iRedMail (MySQL backend only)
date: 2014-03-13T13:50:09+00:00
author: Robert Vojčík
layout: post
guid: http://www.vojcik.net/?p=719
permalink: /command-line-tool-for-iredmail-mysql-backend-only/
categories:
  - Blog
  - HowTos
  - Linux
  - Python
  - SysAdmin
tags:
  - import
  - iredadmin
  - iredmail
  - mysql
---
Hi,

if anyone is interested in  open source mail server solution iRedMail and use MySQL as backend should now use my small cli script. Script has limited functions but it&#8217;s perfect for things like importing new domains or creating many email accounts.

Script is opensource and use some functions from original iredadmin web management. So you need iredadmin installed, which is default option.

[iRedMail CLI Tool on Github](https://github.com/rvojcik/iredmail-cli)

<!--more-->

## Some nice examples

### Basic use

<pre class="brush:shell"># Add new domains
email-manage.py -a -d test.com
Domain added

# Add email but with no existing domain
email-manage.py -a -m test@test.cc
ERROR: Not added, domain test.cc not exist

# Add new email
email-manage.py -a -m test@test.com
Generated new email account:
Username: test@test.com
Password: f5nBpZ6mLZ
Domain: test.com
Initial alias added</pre>

### Change email password

<pre class="brush:shell"># Change password on mailbox, let system to generate random
email-manage.py -w -m test@test.com
Email: test@test.com
Password: T4h7Ty9j6h

Password successfuly updated

# Change password on mailbox, pass new password using argument
email-manage.py -w -m test@test.com -p newpass123
Email: test@test.com
Password: newpass123

Password successfuly updated</pre>

### Search in database

<pre class="brush:shell">email-manage.py -l -d test
+----------+-------------+-----------+-----------+
| domain   | description | transport | Backup MX |
+----------+-------------+-----------+-----------+
| test.com | None        | dovecot   | no        |
+----------+-------------+-----------+-----------+

email-manage.py -l -s test.com
Domains
+----------+-------------+-----------+-----------+
| domain   | description | transport | Backup MX |
+----------+-------------+-----------+-----------+
| test.com | None        | dovecot   | no        |
+----------+-------------+-----------+-----------+
Mailboxes
+---------------+------+----------+--------+-------+
| username      | name | domain   | Active | quota |
+---------------+------+----------+--------+-------+
| test@test.com |      | test.com | yes    | 0     |
+---------------+------+----------+--------+-------+
Aliases
+---------------+---------------+------+----------+--------+
| address       | goto          | name | domain   | Active |
+---------------+---------------+------+----------+--------+
| test@test.com | test@test.com |      | test.com | yes    |
+---------------+---------------+------+----------+--------+</pre>

### Import domains and mailboxes

For example, we have 2 files

  * one with mailboxes &#8220;emails-list.txt&#8221; (one email per line)
  * one with domains  &#8220;domains-list.txt&#8221; (one domain per line)

&nbsp;

<pre class="brush:shell"># First we must add domains
for domain in `cat domains-list.txt` ; do 
    email-manage.py -a -d $domain
done

# Now we can import emails
for email in `cat emails-list.txt` ; do 
    email-manage.py -a -m $email
done</pre>
