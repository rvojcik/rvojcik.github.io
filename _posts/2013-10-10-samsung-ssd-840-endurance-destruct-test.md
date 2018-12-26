---
id: 627
title: 'Samsung SSD 840: Endurance Destruct Test'
date: 2013-10-10T10:35:48+00:00
author: Robert Vojčík
layout: post
guid: http://www.vojcik.net/?p=627
permalink: /samsung-ssd-840-endurance-destruct-test/
categories:
  - Blog
  - Hardware
  - SysAdmin
---
When you operate a Datacenter with many servers you also probably have big number of installed disks. In most cases even you have cluster, especialy in small companies, there is still SPOF (Single point of failure) somewhere.

In this SPOF it&#8217;s critical to know condition of the system. When system using HDD it&#8217;s important to know HDD condition to prevent failures, plan maintenance etc.

We will talk about Samsung SSD 840 PRO series. We realize this SSD has very good performance and lifetime. Before we use it in production we must know how to monitor condition. There is many articles and technical specification but we had a lot of questions without answer.

<p style="text-align: center;">
  <img class=" wp-image-641 aligncenter" src="/wp-content/uploads/2013/06/ssd-disks.jpg" alt="ssd-disks" width="576" height="260" srcset="/wp-content/uploads/2013/06/ssd-disks.jpg 900w, /wp-content/uploads/2013/06/ssd-disks-300x135.jpg 300w" sizes="(max-width: 576px) 100vw, 576px" />
</p>

<p style="text-align: center;">
  <span style="color: #ff0000;">(Update: 10.10.2013)</span>
</p>

<p style="text-align: center;">
  <a title="Samsung SSD 840 PRO – performance degradation" href="/samsung-ssd-840-pro-performance-degradation/"><span style="color: #ff0000;">(Samsung performance issues, read new post, 03.12.2014)</span></a>
</p>

<!--more-->

For example:

  1. What happened when smart normalized value &#8220;Wearleveling count&#8221; (WLC)  drop to 0 ?
  2. Will It effect disk performance ?
  3. How temperature change during utilization of disk ?
  4. How many data can we write to disk without error ?

### Hardware

  * Samsung SSD 840 PRO &#8211; 128 GB
  * Dell Server R320
  * 32 GB ECC Ram
  * 1x CPU, Intel(R) Xeon(R) CPU E5-2420 0 @ 1.90GHz (6 Cores + HT)
  * SAS Controller, Perc H710 NV
  * OS Debian Squeeze
  * Linux Kernel 3.2.2

### Tests

Our test consist of two stages which are in a loop.

Stage 1 is performance test. This test writes 5 GB of data to disk for seq. read/write, rand. read/write, tests. During this stage we write something about 20 GB of data. We measure speed, latency and iops.

Stage 2 is fill test. This test measure all values from Stage 1 but fill whole disk.

All stages writes data with option &#8220;sync&#8221;.

Test server is monitored separately for CPU, Memory, System Load Average, Network, Stats of active Sockets, Number of Processes, IO stats, Disks free space, number of connected users. We also monitor all Smart values from SSD disk.

You may ask, why monitored all these values. Simple answer is, to know what is going on the server. When we will processing the results of these tests, we should see some strange values in some time intervals. We must have additional information what happened to decide this results is false or it&#8217;s real behavior of SSD disk.

I use <a href="http://git.kernel.dk/?p=fio.git;a=summary" target="_blank">FIO</a> utility for all tests on SSD.

Overal I have **58** graphs from the server, most of it&#8217;s smart values.

### Wearleveling count

#### What happened when it drops to 0 ?

Simply nothing :). This value drops to 1 when it writes about **465 TB** of data. This value I count from number of tests and crosscheck with Smart Value &#8211; **&#8220;Total LBAs Written&#8221;**. What I realize this is only prefail value and there was no errors or sectors reallocation. To this days disk wrote another **235 TB** without any errors or reallocations, **and test still continue**.

<img class="alignnone size-full wp-image-636" src="/wp-content/uploads/2013/06/ssd-test-war.png" alt="ssd-test-war" width="603" height="247" srcset="/wp-content/uploads/2013/06/ssd-test-war.png 603w, /wp-content/uploads/2013/06/ssd-test-war-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />

<img class="alignnone size-full wp-image-637" src="/wp-content/uploads/2013/06/ssd-test-lbas1.png" alt="ssd-test-lbas" width="603" height="211" srcset="/wp-content/uploads/2013/06/ssd-test-lbas1.png 603w, /wp-content/uploads/2013/06/ssd-test-lbas1-300x104.png 300w" sizes="(max-width: 603px) 100vw, 603px" />

#### Wearleveling count vs performance

As you can see on graphs below, there is no performance decrease before or after we reach 1% WLC.

<img class="alignnone size-full wp-image-638" src="/wp-content/uploads/2013/06/ssd-test-iostat.png" alt="ssd-test-iostat" width="603" height="337" srcset="/wp-content/uploads/2013/06/ssd-test-iostat.png 603w, /wp-content/uploads/2013/06/ssd-test-iostat-300x167.png 300w" sizes="(max-width: 603px) 100vw, 603px" />

This graphs is only for comparison with indicatively values. You should see no performance decrease during test.

When we want exact values we must look into result logs from fio utility. Section **Graphs from FIO utility** of this article.

### Temperature

In our datacenter temperature of SSD is somewhere around 26 °C. When SSD start writing and reading temperature grow up to 39.9 °C

<img class="size-full wp-image-631 alignnone" src="/wp-content/uploads/2013/06/ssd-test-temp.png" alt="ssd-test-temp" width="603" height="247" srcset="/wp-content/uploads/2013/06/ssd-test-temp.png 603w, /wp-content/uploads/2013/06/ssd-test-temp-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />

### Data written

As I mentioned above, test isn&#8217;t done yet. When I wrote this article, Total LBAs Written was 1503673300498. This value show how many 512 bytes blocks ware written.

LBA_Value * 512 = Bytes written

So we written about **700 TB** to this 128 GB disk. Our tests have 148 GB (128 GB fill disk and 20 GB test disk). We run about 5000 tests which I can see on counter. When we divide 700 TB with 148 GB we get around 4870 tests. It&#8217;s really close, difference is around 3%.

<img class="size-full wp-image-634 alignnone" src="/wp-content/uploads/2013/06/ssd-test-lbas.png" alt="ssd-test-lbas" width="603" height="211" srcset="/wp-content/uploads/2013/06/ssd-test-lbas.png 603w, /wp-content/uploads/2013/06/ssd-test-lbas-300x104.png 300w" sizes="(max-width: 603px) 100vw, 603px" />

### Bandwidth and IOPS

First look on <a href="http://www.samsung.com/us/computer/memory-storage/MZ-7PD128BW" target="_blank">manufacturer site</a> for some specification.

Manufacturer specification:

  * Seq. read up to 530 MB/s
  * Seq. write up to 390 MB/s
  * Rand. read speed up to 97 000 IOPS
  * Rand. write speed up to 90 000 IOPS

Let see my measured values:

  * Seq. read ~ 275 MB/s
  * Seq. write ~ 300MB/s
  * Random read over 250 MB/s
  * Random write ~ 100 MB/s
  * Random read speed ~ 65 000 IOPS
  * Random write speed ~ 28 000 IOPS
  * Seq. read speed ~ 67 000 IOPS
  * Seq. write speed ~ 75 000 IOPS

Quite interesting results.  Some values are similar to manufacturer specification and some are really different.

### Graphs from FIO test utility

<img class="alignnone size-full wp-image-648" src="/wp-content/uploads/2013/06/Samsung-128G-bw.png" alt="Samsung-128G-bw" width="603" height="400" srcset="/wp-content/uploads/2013/06/Samsung-128G-bw.png 603w, /wp-content/uploads/2013/06/Samsung-128G-bw-300x199.png 300w" sizes="(max-width: 603px) 100vw, 603px" />

<img class="alignnone size-full wp-image-649" src="/wp-content/uploads/2013/06/Samsung-128G-IOPS.png" alt="Samsung-128G-IOPS" width="603" height="400" srcset="/wp-content/uploads/2013/06/Samsung-128G-IOPS.png 603w, /wp-content/uploads/2013/06/Samsung-128G-IOPS-300x199.png 300w" sizes="(max-width: 603px) 100vw, 603px" />

&nbsp;

### Conclusion

Test still continues, disk have WLC on 1% but no reserved blocks was used, no reallocation, no errors.

When we reach 1% of WLC, disk write about **465 TB** of data.

It means if your server writes daily **20 GB** of data, it will take **65 years**. For example if you rewrite whole disk every day you reach 1% of WLC in about **10 years**.

If you plan renewal HW every 5 years, you can be safe if you **rewrite whole disk twice a day**.

What I see, it&#8217;s good to monitor these values:

  * Normalized value of WLC
  * Reallocated sector count
  * Normalized value of Used Reserved Blocks Count

### Dictionary

**Wearleveling count** &#8211; The maximum number of erase operations performed on a single flash memory block.

**Reallocated sector count** &#8211; When encountering a read/write/check error, a device remaps a bad sector to a &#8220;healthy&#8221; one taken from a special reserve pool. Normalized value of the attribute decreases as the number of available spares decreases.On a regular hard drive, Raw value indicates the number of remapped sectors, which should normally be zero. On an SSD, the Raw value indicates the number of failed flash memory blocks.

**Used Reserved Blocks Count** &#8211; On an SSD, this attribute describes the state of the reserve block pool. The value of the attribute shows the percentage of the pool remaining. The Raw value sometimes contains the actual number of used reserve blocks.

&nbsp;

### UPDATE 10.10.2013

Our SSD is finaly dead after almost 5 months of heavy write test.

Some numbers

  * more then 3 PB written
  * rewritten more then 24 400 times
  * stable temperature about 37 C

and some nice graphs

[<img class="alignnone size-full wp-image-691" src="/wp-content/uploads/2013/06/realloc-sec-count.png" alt="realloc-sec-count" width="603" height="247" srcset="/wp-content/uploads/2013/06/realloc-sec-count.png 603w, /wp-content/uploads/2013/06/realloc-sec-count-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/realloc-sec-count.png) [<img class="alignnone size-full wp-image-692" src="/wp-content/uploads/2013/06/program-fail-count-total.png" alt="program-fail-count-total" width="603" height="247" srcset="/wp-content/uploads/2013/06/program-fail-count-total.png 603w, /wp-content/uploads/2013/06/program-fail-count-total-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/program-fail-count-total.png) [<img class="alignnone size-full wp-image-693" src="/wp-content/uploads/2013/06/wear-leveling-count.png" alt="wear-leveling-count" width="603" height="247" srcset="/wp-content/uploads/2013/06/wear-leveling-count.png 603w, /wp-content/uploads/2013/06/wear-leveling-count-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/wear-leveling-count.png) [<img class="alignnone size-full wp-image-694" src="/wp-content/uploads/2013/06/used-reserved-blocks.png" alt="used-reserved-blocks" width="603" height="247" srcset="/wp-content/uploads/2013/06/used-reserved-blocks.png 603w, /wp-content/uploads/2013/06/used-reserved-blocks-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/used-reserved-blocks.png) [<img class="alignnone size-full wp-image-695" src="/wp-content/uploads/2013/06/total-lba.png" alt="total-lba" width="603" height="247" srcset="/wp-content/uploads/2013/06/total-lba.png 603w, /wp-content/uploads/2013/06/total-lba-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/total-lba.png) [<img class="alignnone size-full wp-image-696" src="/wp-content/uploads/2013/06/runtime-bad-block.png" alt="runtime-bad-block" width="603" height="247" srcset="/wp-content/uploads/2013/06/runtime-bad-block.png 603w, /wp-content/uploads/2013/06/runtime-bad-block-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/runtime-bad-block.png) [<img class="alignnone size-full wp-image-697" src="/wp-content/uploads/2013/06/power-on-hours.png" alt="power-on-hours" width="603" height="247" srcset="/wp-content/uploads/2013/06/power-on-hours.png 603w, /wp-content/uploads/2013/06/power-on-hours-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/power-on-hours.png) [<img class="alignnone size-full wp-image-698" src="/wp-content/uploads/2013/06/ecc-recovered.png" alt="ecc-recovered" width="603" height="247" srcset="/wp-content/uploads/2013/06/ecc-recovered.png 603w, /wp-content/uploads/2013/06/ecc-recovered-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/ecc-recovered.png) [<img class="alignnone size-full wp-image-699" src="/wp-content/uploads/2013/06/temperature.png" alt="temperature" width="603" height="247" srcset="/wp-content/uploads/2013/06/temperature.png 603w, /wp-content/uploads/2013/06/temperature-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/temperature.png) [<img class="alignnone size-full wp-image-700" src="/wp-content/uploads/2013/06/data-lba-all.png" alt="data-lba-all" width="603" height="247" srcset="/wp-content/uploads/2013/06/data-lba-all.png 603w, /wp-content/uploads/2013/06/data-lba-all-300x122.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/data-lba-all.png) [<img class="alignnone size-full wp-image-701" src="/wp-content/uploads/2013/06/iostat.png" alt="iostat" width="603" height="373" srcset="/wp-content/uploads/2013/06/iostat.png 603w, /wp-content/uploads/2013/06/iostat-300x185.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/iostat.png)

[<img class="alignnone size-full wp-image-703" src="/wp-content/uploads/2013/06/realloc-sect-normalized.png" alt="realloc-sect-normalized" width="603" height="283" srcset="/wp-content/uploads/2013/06/realloc-sect-normalized.png 603w, /wp-content/uploads/2013/06/realloc-sect-normalized-300x140.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/realloc-sect-normalized.png) [<img class="alignnone size-full wp-image-704" src="/wp-content/uploads/2013/06/used_rsvd_blk_count-normalized.png" alt="used_rsvd_blk_count-normalized" width="603" height="283" srcset="/wp-content/uploads/2013/06/used_rsvd_blk_count-normalized.png 603w, /wp-content/uploads/2013/06/used_rsvd_blk_count-normalized-300x140.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/used_rsvd_blk_count-normalized.png) [<img class="alignnone size-full wp-image-705" src="/wp-content/uploads/2013/06/wear-normalized.png" alt="wear-normalized" width="603" height="283" srcset="/wp-content/uploads/2013/06/wear-normalized.png 603w, /wp-content/uploads/2013/06/wear-normalized-300x140.png 300w" sizes="(max-width: 603px) 100vw, 603px" />](/wp-content/uploads/2013/06/wear-normalized.png)

&nbsp;

UPDATE: [<span style="color: #ff0000;">(Samsung performance issues, read new post, 03.12.2014)</span>](/samsung-ssd-840-pro-performance-degradation/ "Samsung SSD 840 PRO – performance degradation")
