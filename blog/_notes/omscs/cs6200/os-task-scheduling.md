---
layout: post
type: note
title: "Notes on Scheduling in Operating Systems"
color: badge-accent-3
icon: fa-code
date: 2018-04-29
categories:
  - operating systems
  - scheduler
  - scheduling algorithms
description:
  "Notes on OS task scheduling -- runqueues, scheduling policies, timeslices, etc."
---
This note will be **very** loosely structured -- it's just to help me organize my thoughts around how the operating systems schedule tasks and prepare for the final exam in CS6200.

## What does an OS Scheduler Do?
Decides when processes and threads have access to run on a system's CPUs. There are often multiple tasks ready to be run on the system at any given time. It is the scheduler's job of determining which task gets to run next.

## What is a Runqueue / Ready Queue?
A data structure containing tasks that are ready (and waiting) to be scheduled and executed on the CPU.

Runqueues can be simple first-in-first-out (FIFO) queues, [priority trees](https://en.wikipedia.org/wiki/Priority_search_tree), or something else.

## When do tasks enter the runqueue (ready queue)?
Tasks typically enter the ready queue when a **process/thread is created**, when there is an **interrupt**, when the **timeslice a task is running in has expired**, and when a **task completes an I/O operation**.

## When does the Scheduler run?
Some times when the scheduler will run are when a **timeslice has expired**, when **the CPU is idling**, and when **new tasks enter the runqueue**.

## What is a Timeslice?
A timeslice (time slice?) is a window of time during which a task can run on a CPU. [Timeslicing](https://en.wikipedia.org/wiki/Preemption_(computing)#Time_slice) is a mechanism for preempting running tasks and every time a timeslice is up (aka expired) the scheduler will run and choose a task to run in the next timeslice. Shorter timeslices are better for I/O-bound tasks since they typically use a small amount of CPU before blocking on I/O while longer timeslices can be better for CPU-bound tasks since they make use of the CPU during the entire time window and will need to context switch less.

# Scheduling Policies
## First Come First Served (FCFS)
Simple scheduling policy that typically uses a FIFO runqueue and just runs tasks in the order that they've entered the queue. Long tasks can starve others that are in the back of the queue.

## Round Robin Scheduling
Similar to FCFS, tasks are picked up in a FIFO manner, but when a task yields (e.g. blocking I/O) or a timeslice has expired the task will be placed in the back of the queue and the next one will be picked up.

## Shortest Job First (SJF)
Jobs are executed in order of their expected execution time (using heuristics to estimate how long they will run?). Typically uses a binary tree or an ordered queue to determine what to run next.

## Multi-level Feedback Queues (MLFQ)
The OSTEP book does a good job [explaining multi-level feedback queues](http://pages.cs.wisc.edu/~remzi/OSTEP/cpu-sched-mlfq.pdf). In general, a MLFQ consists of multiple subqueues (multiple levels) and tasks will find their way into the appropriate level as a way of prioritizing them. Higher levels in the queue equal higher runpriority.

A task will enter the queue at the highest priority level will drop down to lower levels the longer it takes to end/yield.

This means that a MLFQ will favor tasks that yield quickly (e.g. short tasks or I/O bound tasks) and these tasks will end up at higher levels in the queue. Tasks that are very long-running and CPU intensive will drop down to lower levels of the queue.

# Scheduling in Linux

## O(1) Scheduler
The [O(1) scheduler](https://en.wikipedia.org/wiki/O(1)_scheduler) in Linux took constant time to select a task to run and add new tasks to the queue. It worked by having two queues with 140 priority (nice) levels. Lower nice numbers == higher priority.

The "Active Queue" contains tasks that will be run next in order of priority. As timeslices expire the currently running tasks are moved out of the active queue and in to the "Expired Queue". Once the Active Queue is empty it is swapped out with the Expired Queue and their roles reverse.

## Completely Fair Scheduler (CFS)
The [Completely Fair Scheduler](https://en.wikipedia.org/wiki/Completely_Fair_Scheduler), or CFS, was a replacement for the O(1) scheduler and takes O(1) time to select a tasks and O(log n) time to add a task (where n is the number of tasks currently in the queue). It uses a [red-black tree](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree) as its queue where tasks are weighted by their "vruntime" values -- the amount of time the task has been running on the CPU weighted by its priority. Left-most nodes in the tree have lower vruntimes and the left-most node is always selected to be scheduled next.

## Resources
### Relevant OSTEP Chapters
Chapters 7-10 in [Operating Systems: Three Easy Pieces](http://pages.cs.wisc.edu/~remzi/OSTEP/#book-chapters) cover a few topics related to task scheduling. Below are a few chapters that I believe to be particularly relevant in this class.
* [CPU Scheduling](http://pages.cs.wisc.edu/~remzi/OSTEP/cpu-sched.pdf)
* [Multi-level Feedback Queues](http://pages.cs.wisc.edu/~remzi/OSTEP/cpu-sched-mlfq.pdf)
* [Multi-CPU Scheduling](http://pages.cs.wisc.edu/~remzi/OSTEP/cpu-sched-multi.pdf)

### Other Resources
* [Scheduling Policy Notes](http://web.cse.ohio-state.edu/~agrawal.28/660/Slides/jan18.pdf)
