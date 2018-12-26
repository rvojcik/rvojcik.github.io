---
id: 518
title: BASH GIT prompt
date: 2012-11-28T22:48:01+00:00
author: Robert Vojčík
layout: post
guid: /?p=518
permalink: /bash-git-prompt/
categories:
  - Bash
  - Blog
  - Linux
---
I&#8217;d like to introduce you my bash shell which can handle GIT information.

More information and sources are hosted on [Github](http://https://github.com/rvojcik/bash-git-prompt "Bash GIT Prompt on Github").


<img class="alignnone" alt="" src="/wp-content/bash-git/basic.png" width="289" height="63" />

<!--more-->

Let&#8217;s start from left, first is login & hostname combination followed by background processes counter and end with current directory.
  
Next line start with actual bash history position.

&nbsp;

## Working with GIT

<img class="alignnone" alt="" src="/wp-content/bash-git/git-base.png" width="336" height="74" />

When you enter some git repository, prompt give you some extra line with GIT information. Line starts with word **GIT** and actual branch name.

There are also some extra chars and numbers. They represent uncommited changes in your repository (like git status).

M &#8211; modified files

A &#8211; added files

D &#8211; deleted files

When you do some changes, prompt show you actual status of your git repository

## Add file to GIT

<img class="alignnone" alt="" src="/wp-content/bash-git/git-add-file.png" width="335" height="206" />

## Modify file managed by GIT

<img class="alignnone" alt="" src="/wp-content/bash-git/git-mod-file.png" width="341" height="148" />

## Local repository vs remote

When you do some changes and commit them, your state is 1 commit ahead of remote.
  
It is very useful to know how many commits you have unpushed.

<img class="alignnone" alt="" src="/wp-content/bash-git/git-1-ahead.png" width="397" height="454" />

Another situation could be, you are working on your local repository and you do \*\*git fetch\*\* to get files from remote repository. Prompt show you how many commits you are behind of remote.

<img class="alignnone" alt="" src="/wp-content/bash-git/git-1-behind.png" width="395" height="370" />

Small arrow show you commits flow and it&#8217;s followed by number of commits

->   you are ahead of remote

-<-   you are behind of remote

## Stashing

Prompt support also stash signalization

<img class="alignnone" alt="" src="/wp-content/bash-git/git-1-stash.png" width="471" height="373" />

&nbsp;
