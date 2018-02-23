---
layout: post
type: note
title: "Notes on Multithreading in Solaris"
color: indigo
icon: fa-code
date: 2018-02-19
categories:
  - operating systems
  - multithreading
  - solaris
description:
  "Notes on various papers covering how multithreading is implemented in the SunOS and Solaris operating systems"
---

## Data Structure Summary
### Process
Data is contained within a `proc` structure.
`proc` structure includes:
1. list of kernel threads for the process
2. pointer to the process address space
3. user credentials
4. signal handlers

### Light-weight Process (LWP)
Contains the process-control-block, or PCB. The PCB includes:
1. user-level process registers
2. syscall arguments
3. signal handling masks
4. resource usage
5. profiling pointers

The LWP also includes:
1. pointers to the kernel thread associated with the LWP
2. `proc` structure for the LWP

**See:** [additional notes on light-weight processes]({% link _notes/omscs/cs6200/processes.md %})

### Kernel-thread
Kernel thread structure contains:
1. kernel registers
2. scheduling class
3. dispatch queue links
4. pointer to stack
5. pointer to associated LWP
6. pointer to associated process structure
7. pointer to CPU structure

### CPU
The `cpu` structure contains per-processor data, including:
1. pointer to currently executing thread
2. the idle thread for the CPU
3. current dispatching and scheduling information
4. other architecture-dependent information

## "Interrupts as Threads" Summary
SunOS 5.0 had preallocated threads dedicated to handling interrupts. These threads would perform the interrupt work and the interrupted thread would be "pinned" and could not be scheduled while until the interrupt thread finished.

This eliminates the need of raising and lowering interrupt priority to prevent deadlocks from occurring because an interrupt that wants to lock a mutex interrupts something that already has a lock on the mutex (maybe? 🙂 still a little fuzzy on this part of the paper).

## Resources
* [Multithreading in the Solaris™ Operating Environment](https://web.archive.org/web/20090327002504/http://www.sun.com/software/whitepapers/solaris9/multithread.pdf)
* [Beyond Multiprocessing ... Multithreading the SunOS Kernel](https://www.usenix.org/legacy/publications/library/proceedings/sa92/eykholt.pdf)
* [Implementing Lightweight Threads](https://www.usenix.org/legacy/publications/library/proceedings/sa92/stein.pdf)
