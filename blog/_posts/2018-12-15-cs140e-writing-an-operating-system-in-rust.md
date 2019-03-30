---
layout: post
type: blog
title: "Learning to build an Operating System in Rust via CS140e"
sub_title: "rust is gr8"
color: red
icon: fa-cog
date: 2018-12-15
last_modified_at: 2019-03-30
categories:
  - stanford cs140e
  - rust operating systems course
  - operating systems
  - rust
excerpt: "I first found out about Stanford's experimental Rust-based Operating Systems course via the GATech OMSCS Slack. I was intrigued by the fact that the course combined two of my favorite topics: the Rust programming language and Raspberry Pis. Now that I've hit a bit of a lull, having just wrapped up grad school for the semester, I've finally had a few cycles to spare and really dig in to the material in Stanford's CS140e."
description:
  "How to \"sit in\" on Stanford's CS140e Operating Systems course and learn how to write a basic operating system for the Raspberry Pi in Rust."
---

<div>
<img src="https://images.downey.io/blog/cs140e-rust-ferris-crochet-downey-1.jpg" alt="Raspberry Pi 3 running CS140e code with crocheted Ferris crab">
</div>

## ⚠️ important update ⚠️
It was brought to my attention that the [cs140e site](https://web.stanford.edu/class/cs140e/) has been completely redone and the class is now being taught in C. 😒 Fortunately, the Internet Archive has [an archived version](https://web.archive.org/web/20180809015024/http://web.stanford.edu/class/cs140e) that will still let you access the assignments. I also recommend checking out Philipp Oppermann's [Writing an OS in Rust](https://os.phil-opp.com/) blog series. I've only had a chance to skim the content, but it looks like another good alternative.

## introduction

I first found out about [Stanford's experimental Rust-based cs140e OS course](https://web.stanford.edu/class/cs140e/) through a comment on the OMSCS [GIOS](https://www.omscs.gatech.edu/cs-8803-introduction-operating-systems) Slack. Now I'm always down to learn more about Operating Systems, but what really hooked me was the fact that the course combined two of my favorite topics: the Rust programming language and Raspberry Pis ([check out my Raspberry Pi Kubernetes cluster 😊]({% post_url 2018-08-04-how-to-build-raspberry-pi-kubernetes-cluster %})). Now that my [machine learning courses]({% post_url 2018-12-09-thoughts-on-omscs-cs-7641-machine-learning %}) are behind me, I've finally had a few cycles to spare and really dig in to the material.

First of all, CS140e is not a MOOC. It's just a regular, albeit experimental, undergraduate class taught on-campus at Stanford. That means there are no recorded lectures available or really even any guidance. There's just a [course site](https://web.stanford.edu/class/cs140e/) with a handful of well specified assignments published. However, the concept of learning how to build a basic OS in Rust is compelling enough that the course has gone viral on [Hacker News](https://news.ycombinator.com/item?id=16134618) and has even spawned a [Reddit community](https://www.reddit.com/r/cs140e/) full of folks independently working through the assignments. This weekend I had a chance to work through the initial starter assignment, [blinky](https://web.stanford.edu/class/cs140e/assignments/0-blinky/) and had a lot of fun. Reading data sheets and manipulating hardware registers reminded me a lot of the microcontroller-based systems courses ([C335](https://homes.sice.indiana.edu/classes/fall2018/csci/c335-geobrown/))I took as an undergrad at IU and was a nice change of pace from the typical software development I do at work.

As an outsider "sitting in" on this course, however, it can be a bit hard to figure out what exact hardware and reference materials you need to begin. Here's what I used:

## Parts List and Materials

<ul>
  <li><a href="https://www.adafruit.com/product/3055"><strong>1x</strong> Raspberry Pi 3 Model B</a></li>
  <li><a href="https://amzn.to/2Lh3jAf"><strong>1x</strong> DSD TECH USB to TTL Serial Converter CP2102</a></li>
  <li><a href="https://amzn.to/2PEUP6n"><strong>1x</strong> Generic Electronics Learning Kit (resistors, LEDs, breadboard, etc.)</a></li>
  <li><a href="https://amzn.to/2M4hRWw"><strong>1x</strong> 32GB Sandisk Ultra MicroSD Card (feel free to go smaller)</a></li>
  <li><a href="https://amzn.to/2QSNIvX"><strong>1x</strong> SunFounder RAB Holder</a></li>
  <li><strong>1x</strong> Computer running Linux or Mac OS X</li>
</ul>

The most important component you'll need is a Raspberry Pi 3 Model B. Folks have reported [issues with the 3 B+](https://www.reddit.com/r/cs140e/comments/8rbmjk/can_i_use_raspberry_pi_3b_to_replace_the_3b/) in this course and you'll want to make sure you're using the same ARM platform and pinout since the assignments call out specific pins and registers.

You'll also want to get a CP2102 compatible USB to TTL Serial Converter since the assignments rely on it to power the Pi and communicate with it.

For the electronics kit, you mostly will just want to have a breadboard, a decent variety of resistors, and some LEDs on hand. Someone recommended the kit I listed in the Hacker News thread I linked earlier and it's worked out fine for me so far. The quality is a bit lacking, but for ~12 bucks it's hard to beat.

You really could get buy with a small, 4GB SD card, but it's hard to come about those these days. I picked up several 32GB ones for cheap on Black Friday and went with those.

Lastly, I purchased a "RAB" holder (I think it stands for Raspberry Pi, Arduino, Breadboard holder) from SunFounder just so I had a platform to keep everything tidy. 

## Preparation

I've taken Operating Systems courses before and have [worked with STM32 ARM microcontrollers](https://github.com/tcdowney/thelittlehaskells) in the past so the newest bit for me was mainly the Rust aspect. This meant that the detailed assignment descriptions and Reddit community were enough for me at least to get started. However, you're brand new to writing software that interacts with hardware or operating systems concepts, you may have a difficult time since there are no recorded lectures or instructional guidance available for those of us dropping in.

### Hardware Programming Prep
If phrases like "setting and clearing registers" or "configuring pins" are unfamiliar to you, I recommend starting out by learning some Arduino. Arduino libraries are implemented in C and working through [Adafruit's Arduino Lessons](https://learn.adafruit.com/series/learn-arduino) is a good way to get acquainted with the domain in a beginner-friendly environment.

### Operating Systems Concepts Prep
There's a whole lot to learn around how Operating Systems work. Although the aim of CS140e is to teach them, since you're missing out on the lectures and textbook for this class you kinda have to blaze your own trail.

For lectures, I really enjoyed Dr. Ada Gavrilovska's recorded lectures for Georgia Tech's CS6200 course. They're available on Udacity [here](https://www.udacity.com/course/introduction-to-operating-systems--ud923). For the assignments in CS140e it's probably best to check out the lectures on scheduling, concurrency, and memory page tables.

For a textbook, I'm a huge fan of the [Operating Systems: Three Easy Pieces](http://pages.cs.wisc.edu/~remzi/OSTEP/) book. Not only is it free to read online, but it's also (in my opinion) easier to understand than comparable texts that cost hundreds of dollars.

### Rust Language Prep
Although [Assignment 1](https://web.stanford.edu/class/cs140e/assignments/1-shell/) attempts to introduce students to Rust, it can be insufficient -- especially if you're coming from a higher level language like Javascript or Python. I recommend using the [Rust Programming Language](https://doc.rust-lang.org/book/) as a reference and going through the "Introduction" chapter initially.

## CS140e Assignments and Takeaways

There's only three real assignments available (and an introductory Assignment 0), but they're pretty involved. You'll start by making an interactive shell that runs on the Raspberry Pi, complete with some utilities and drivers, in Assignment 1. Then move on to implementing a FAT32 filesystem in Assignment 2 and the abilitity to spawn user-level processes in Assignment 3.

I'm personally still on Assignment 1 since, between work and grad school, I don't have as much time as I'd like to dedicate to this hobby coursework. So far it's been a lot of fun and I'm hoping to make some good progress before the GATech Spring 2019 semester starts.

My advice is to make sure you're using the exact versions of Rust nightly and xargo as they mention in Assignment 0, otherwise you'll end up with hard to debug compile toolchain issues. If you get stuck, the [Reddit community](https://www.reddit.com/r/cs140e/comments/7ql4fw/info_general_discussion/) is a good place to turn and there's plenty of completed projects on Github you can peak at for clues. Just search for "cs140e" (I bet the instructors love this 😅).

My original goal with this course was to use it as an avenue to learn Rust, but unfortunately I feel like I'm just writing C with a diffent syntax and compiler at this point. So if you're hoping to use CS140e to learn Rust as well, I think you may be better off just working through the Rust book and writing a crate or small CLI. If you're looking to learn how to do low-level hardware development in Rust, though, CS140e does seem quite useful.

I'm mostly just excited to see academic courses incorporate Rust in to their curriculums and am pumped that a course like CS140e even exists. Here's to hoping they finish the rest of the planned assignments for the course and maybe even make it in to a true MOOC that's accessible to all. The demand clearly exists, after all you found this post somehow. Cheers!
