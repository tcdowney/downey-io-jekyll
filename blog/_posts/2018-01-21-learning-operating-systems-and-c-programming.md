---
layout: post
type: blog
title: "Learning Operating Systems and Rediscovering C"
sub_title:  "A Ruby dev's rambling journey deeper down the stack"
color: green
icon: fa-book
date: 2018-01-21
last_modified_at: 2018-02-09
categories:
  - programming
  - c programming language
  - learning operating systems
  - omscs graduate introduction to os
  - georgia tech omscs cs 6200
excerpt:
 "One of my goals this year is to learn more of the underlying concepts and theory of operating systems and improve my systems programming skills. Consequentially, I've enrolled in Graduate Introduction to Operating Systems through Georgia Tech this semester to help meet this goal. However, it's been a few years since I've written any C and I never had the opportunity to take an Operating Systems course in undergrad so I've got some ground to cover. This post is currently a work in progress, but I'll add to it over time to document my learning journey and include links to any resources that proved helpful along the way."
description:
  "One of my goals this year is to learn more of the underlying concepts and theory of operating systems and improve my systems programming skills. Consequentially, I've enrolled in Graduate Introduction to Operating Systems through Georgia Tech this semester to help meet this goal. However, it's been a few years since I've written any C and I never had the opportunity to take an Operating Systems course in undergrad so I've got some ground to cover. This post is currently a work in progress, but I'll add to it over time to document my learning journey and include links to any resources that proved helpful along the way."
---

<div>
<img src="https://images.downey.io/blog/learning-operating-systems.jpg" alt="Open facing Operating Systems in Three Easy Pieces and closed The Linux Programming Interface books">
</div>

> I'm going to be experimenting a bit with this post. It's currently a work in progress that I plan on fleshing out over the coming months as I learn more about the topic and stumble upon new resources. I always intend on blogging about my OMSCS coursework after a particularly interesting class ends, but never actually get around to doing it ([KBAI](https://www.omscs.gatech.edu/cs-7637-knowledge-based-artificial-intelligence-cognitive-systems) I'm looking at you 👀). It should end up being on the longer side of my posts and I anticipate wrapping it up in May or June.

**Update (2018-02-09):** Just completed a week-long Linux training and the first project in GIOS. Updated this post with my thoughts on the training and added some learning strategies for GIOS.

## Motivation Behind Learning OS Concepts

One of my goals this year is to learn more of the underlying concepts and theory of operating systems and improve my systems programming skills. Consequentially, I've enrolled in [Graduate Introduction to Operating Systems (CS 6200)](https://www.omscs.gatech.edu/cs-8803-introduction-operating-systems) (referred to as GIOS from here on out) through Georgia Tech's [OMSCS program](https://www.omscs.gatech.edu/) this semester to help meet this goal. However, it's been a few years since I've written any C and I never had the opportunity to take an Operating Systems course in undergrad so I've got some ground to cover. This post is currently a work in progress, but I'll add to it over time to document my learning journey and include links to any resources that proved helpful along the way.

If you're intrested in the course the recorded lectures are available to anyone via [Udacity](https://classroom.udacity.com/courses/ud923).

## Approach Toward the Class
I've currently made it through the first month and a half of the course and have completed the first project. If you're currently taking this course and are interested, this is the approach I've taken so far. If not, feel free to skip ahead to the [learning resources](#general-operating-systems-and-c-language-resources) section of this post.

### Lecture Videos
The lectures for the course are all pre-recorded and available through Udacity. However, I generally try to find time to squeeze them in and watch them in places where I don't typically have unlimited internet access: such as on the BART during my commute or in the gym.

Fortunately, Udacity lets you download the videos in bulk so I just toss them on to my Kindle Fire tablet that I picked up for about thirty bucks during Black Friday. I watch them using [VLC media player](https://www.videolan.org/vlc/index.html) since it allows me to adjust the playback speed.

### Office Hours
Office hours with the professor and TAs typically occur during Eastern time since the program is based out of Atlanta, GA which means I usually can't attend them live. The professor usually uploads them to Youtube, however, so I download and watch them after the fact. It's not ideal since I can't ask questions while the office hours are being held, but it does mean I can fast forward any questions that aren't personally relevant.

### Piazza and Slack
The TAs in this course are incredibly active in the [class Slack](https://omscs6200.slack.com/messages/C6KPYD8AK/). They can be a little sassy at times, but are super responsive to questions which has been nice.

### Textbook
The course doesn't have a required textbook this semester, but I bought one of the recommendations: [Operating Systems: Three Easy Pieces](http://pages.cs.wisc.edu/~remzi/OSTEP/). It's available for free online, but a hardcover copy was only around thirty dollars. I haven't actually needed to use it yet, but we'll see. 😬

### Papers and Readings
The course has a number of assigned papers and some of them can be pretty dry. I generally follow the strategy put forth in this meta-paper on how to effectively read an academic paper: [How to Read a Paper](https://blizzard.cs.uwaterloo.ca/keshav/home/Papers/data/07/paper-reading.pdf). It was first introduced to me in a Computer Networking course and has been pretty helpful so far.

## General Operating Systems and C Language Resources
Below are some of the resources that helped me prepare and learn various operating systems topics throughout the course. Like this whole post, the format is still a work in progress.

### Learning C
* [The C Programming Language](https://www.amazon.com/Programming-Language-2nd-Brian-Kernighan/dp/0131103628/ref=as_li_ss_tl?_encoding=UTF8&me=&linkCode=ll1&tag=15ab7a4c1c94-20&linkId=0a592b1eb4128f1035ce9a79d92edead)
  * This is the quintessential guide to C written by the language's creators themselves. I had worked through it previously in undergrad, but sold my copy back to the bookstore. I repurchased it and am now using it more as a reference.

### Learning Linux Syscalls and the GNU C Library (glibc)
* [The Linux Man Pages](http://man7.org/linux/man-pages/)
  * The Linux manual pages have been very helpful for learning about various syscalls and their associated standard library functions. My go to now is to search "man pread" for example when I want to know how to use a library function and what the various flags available are.
* [The Linux Programming Interface](http://amzn.to/2FVV4FR)
  * This book has also been invaluable while working on my GIOS projects. It's chapters on POSIX threads and sockets/poll have been especially helpful on the first project so far.

### Thread Theory
* [An Introduction to Programming with Threads by Andrew D. Birrel](https://birrell.org/andrew/papers/035-Threads.pdf)
  * This paper was a required reading for CS 6200 and despite it's age (published in 1989) still delivers a concise explanation around threading and mutexes.

### Sockets and Network Programming
* [Beej's Guide to Network Programming](http://beej.us/guide/bgnet/)
  * This site has helped me tremendously so far with the first project in CS 6200 -- writing a basic multi-threaded web server in C.

## System Programming for Linux Containers Training
This February I was given the opportunity through work to attend a week-long intensive training with Michael Kerrisk, the author of The Linux Programming Interface referenced above.

We attended his [System Programming for Linux Containers](http://man7.org/training/sys_prog_lxcon/index.html) course which I found immensely helpful.

The first couple of days covered some Linux basics such as syscalls, file permissions, and processes. He covers all of this in his book, but I found the format of the in-person course really conducive to learn. It actually helped me finish my first project in GIOS.

The latter half of the week covered [cgroups](https://en.wikipedia.org/wiki/Cgroups), [capabilities](http://man7.org/linux/man-pages/man7/capabilities.7.html), [seccomp](https://en.wikipedia.org/wiki/Seccomp), and [namespaces](https://en.wikipedia.org/wiki/Linux_namespaces) -- all of the core Linux features that enable the creation and use of containers.

I'm considering doing some further research on these topics and making a dedicated post synthesizing some of what I learned, but until then I recommend checking out this post to see how all of these topics come together to make a container: [Linux containers in 500 lines of code](https://blog.lizzie.io/linux-containers-in-500-loc.html)

At [Cloud Foundry](https://www.cloudfoundry.org/) we're all about running applications in containers. However for me personally, most of my work has been in Ruby at some of the higher levels of the platform. The lower layers, such as the [garden-runc](https://docs.cloudfoundry.org/concepts/architecture/garden.html#garden-runc) containerization component, have, until now, been a bit of a black box to me. This week of training, however, has helped demystify containers for me and that makes me very excited to learn more. 😊

## Future Exploration
These are resources that I haven't had a chance to go through yet, but look like a lot of fun.
* [Building an Operating System for the Raspberry Pi](https://jsandler18.github.io/)
  * A tutorial around creating your own operating system for the Raspberry Pi.
