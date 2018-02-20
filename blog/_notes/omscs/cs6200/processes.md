---
layout: post
type: note
title: "Notes on Processes"
color: subaru-orange
icon: fa-code
date: 2018-02-19
categories:
  - operating systems
  - processes
description:
  "Notes on processes"
---
This note will be loosely structured -- it's just to help me organize my thoughts around the OS Process abstraction (mostly Unix processes) and prepare for the first exam in CS6200.

## Light-weight Processes
TBD
* [Wiki link](https://en.wikipedia.org/wiki/Light-weight_process)

## Process States
<dl>
  <dt>READY</dt>
  <dd>Ready for the Scheduler to run the process, but not currently running</dd>
  <dt>RUNNING</dt>
  <dd>Process is currently being executed by the OS. Processes will move between RUNNING and READY as other processes get a chance to run</dd>
  <dt>BLOCKED</dt>
  <dd>Process is blocked on something (e.g. I/O) and not ready to be scheduled</dd>
</dl>

## Resources
* [OSTEP - Chapter 4](http://pages.cs.wisc.edu/~remzi/OSTEP/cpu-intro.pdf)
* [fork syscall man page](http://man7.org/linux/man-pages/man2/fork.2.html)
