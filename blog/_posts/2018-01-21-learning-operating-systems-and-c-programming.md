---
layout: post
type: blog
title: "Learning Operating Systems Concepts and Revisiting C"
sub_title:  "A Ruby dev's rambling journey deeper down the stack"
color: green
icon: fa-book
date: 2018-01-21
categories:
  - programming
  - c programming language
  - learning operating systems
  - omscs graduate introduction to os
  - georgia tech omscs cs 6200
excerpt:
 "This year I've decided to ramp up on my understanding of operating systems and brush up on my C skills for a variety of reasons. Currently this post is a work in progress, but eventually it will chronicle my learning journey and include links to any resources that proved helpful along the way."
description:
  "Resources that I've found helpful for learning operating systems related topics and systems programming."
---

> I'm going to be experimenting a bit with this post. It's currently a work in progress that I plan on fleshing out over the coming months as I learn more about the topic and stumble upon new resources. I always intend on blogging about my OMSCS coursework after a particularly interesting class ends, but never actually get around to doing it ([KBAI](https://www.omscs.gatech.edu/cs-7637-knowledge-based-artificial-intelligence-cognitive-systems) I'm looking at you 👀). It should end up being on the longer side of my posts and I anticipate wrapping it up in May or June.

## Motivation Behind Learning OS Concepts

Since graduating, my day job has primarily consisted of writing web applications using high-level interpreted languages like Ruby and Javascript. Apart from a little bit of Chef used for deployments and server configuration, I didn't need to know much about the underlying infrastructure or OS. Lately, however, now that I work on [Cloud Foundry ](https://www.cloudfoundry.org/) there have been times when I did wish I had a better understanding of the OSes that we target and how containerization works in Linux.

Luckily, I'm currently working on my master's through Georgia Tech's [OMSCS program](https://www.omscs.gatech.edu/), so this semester I'm taking their [Graduate Introduction to Operating Systems (CS 6200)](https://www.omscs.gatech.edu/cs-8803-introduction-operating-systems) course. Although it doesn't include the class projects, the recorded lectures are available to anyone via [Udacity](https://classroom.udacity.com/courses/ud923).

## Approach Toward the Class
So far in these first weeks of the course I have just been watching lectures and working on the first project. Will flesh out this section more as time goes on.

## Learning Resources
Below are some of the resources that helped me prepare and learn various operating systems topics throughout the course. Like this whole post, the format is still a work in progress.

### Learning C
* [The C Programming Language](https://www.amazon.com/Programming-Language-2nd-Brian-Kernighan/dp/0131103628/ref=as_li_ss_tl?_encoding=UTF8&me=&linkCode=ll1&tag=15ab7a4c1c94-20&linkId=0a592b1eb4128f1035ce9a79d92edead)
  * This is the quintessential guide to C written by the language's creators themselves. I had worked through it previously in undergrad, but sold my copy back to the bookstore. I repurchased it and am now using it more as a reference.

### Threads
* [An Introduction to Programming with Threads by Andrew D. Birrel](https://birrell.org/andrew/papers/035-Threads.pdf)
  * This paper was a required reading for CS 6200 and despite it's age (published in 1989) still delivers a concise explanation around threading and mutexes.

### Sockets and Network Programming
* [Beej's Guide to Network Programming](http://beej.us/guide/bgnet/)
  * This site has helped me tremendously so far with the first project in CS 6200 -- writing a basic multi-threaded web server in C.

## Future Exploration
These are resources that I haven't had a chance to go through yet, but look like a lot of fun.
* [Building an Operating System for the Raspberry Pi](https://jsandler18.github.io/)
  * A tutorial around creating your own operating system for the Raspberry Pi.
