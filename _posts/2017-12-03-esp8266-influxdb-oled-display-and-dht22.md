---
id: 843
title: ESP8266 + InfluxDB + OLED DIsplay and DHT22
date: 2017-12-03T16:19:21+00:00
author: Robert Vojčík
layout: post
guid: https://www.vojcik.net/?p=843
permalink: /esp8266-influxdb-oled-display-and-dht22/
categories:
  - Blog
---
Basicly just put together from Examples.

Sending data tu InfluxDB was little bit tricky using HTTPClient and POST method for InfluxDB.

![img1](/wp-content/uploads/2017/12/14c35e4f-1f66-41bd-a4bf-6ee4dc070719-e1512314269987-300x156.jpg)
  
<!--more-->

```C
#include 
HTTPClient client;
char server[] = "xxx.xxx.xxx.xxx";

//Create Strings from float temperatures
String s_t1 = String(t1);
String s_t2 = String(t2);
String s_h1 = String(h1);
String s_h2 = String(h2);

// Send data to influxDB directly
// Prepare line for POST method 
// Just Add any tags you like
// This line create measurement AirSensor and send 4 values (t1,t2,h1,h2) with some simple tags
line = String("AirSensor,location=home,room=livingroom t1=" + s_t1 + ",t2=" + s_t2 + ",h1=" + s_h1 + ",h2=" + s_h2);

// Create connection to our server and use influx database called sensors
// Run CREATE DATABASE sensors; on your influxdb server
client.begin(server, 8086, "/write?db=sensors");
// Debug only
Serial.println(line);
// Make a HTTP request:
client.addHeader("Content-Type", "application/x-www-form-urlencoded");
int httpcode = client.POST(line);
client.end();
Serial.println(httpcode);
```

So, simple one. I&#8217;m putting it here just becouse it was not easy to find good example of posting data directly to influxDB.

Enjoy

Sample Grafana Dashboard

[<img class="aligncenter wp-image-845 size-thumbnail" src="/wp-content/uploads/2017/12/d8e37ef1-c481-4a6e-bdc1-7b5af119ccf6-e1512314347432-150x150.jpg" alt="" width="150" height="150" />](/wp-content/uploads/2017/12/d8e37ef1-c481-4a6e-bdc1-7b5af119ccf6-e1512314347432.jpg)
