---
layout: post
type: note
title: "Notes on Synchronization Constructs in Operating Systems"
color: violet
icon: fa-code
date: 2018-04-29
categories:
  - operating systems
  - synchronization constructs
  - mutexes
  - semaphores
  - spin locks
description:
  "Notes on OS synchronization constructs -- mutexes, semaphores, spin locks, etc."
---
This note will be **very** loosely structured -- it's just to help me organize my thoughts around how the various synchronization constructs that we've covered in OMSCS CS6200 and prepare for the final exam.

## What is a Spin Lock?
A spin lock is a construct that functions similarly to a mutex. It is mutually exclusive in that only one process/thread can hold the lock at a time. Spin locks surround critical sections of code similarly to how a mutex would:

```
spinlock_lock(&spinlock)
// critical section here
spinlock_unlock(&spinlock)
```

key differentiator here is that while others are waiting to acquire a spin lock, they just "spin" -- churning and consuming CPU cycles. The thread doesn't block, but instead continually checks to see if it can acquire the lock, burning CPU cycles until the lock is free or it gets preempted (related [OS scheduler notes]({% link _notes/omscs/cs6200/os-task-scheduling.md %})).

Spin locks are useful for short (fast) critical sections since it is likely whatever is holding the lock will finish faster than a context switch would take. However, for longer critical sections, having a lot of spin lock consumers will consume CPU resources and can affect the performance of other processes.

## What is a Semaphore?
A [semaphore](https://en.wikipedia.org/wiki/Semaphore_(programming)) is like a more general mutex. They are initialized with an integer value that denotes that max number of concurrent threads that can use the semaphore. For example, if a sempahore is initialized with `4`, then four different threads can use it, each one decrementing the counter while using it and incrementing it back up when they're done. If a semaphore's counter is at `0`, additional threads must wait.

You can think of a mutex as a semaphore that was initialized with `1` since only one thread can claim it at a time.

## What are Reader Writer Locks (rwlock)?
Often times the type of access to a resource affects how strict the locking of it needs to be. For example, for a file it might not matter how many consumers read from it simultaneously, but it **does matter** how many write to it.

In these cases, [reader writer locks](https://en.wikipedia.org/wiki/Readers%E2%80%93writer_lock) can be used which allow unlimited concurrent access for reads, but exclusive access for writes. When a writer holds the lock all other consumers wishing to read or write are blocked.

## What are Monitors?
[Monitors](https://en.wikipedia.org/wiki/Monitor_(synchronization)) are deemed "higher order" synchronization constructs that absract away locking and condition variables around a resource. They include information around the various entrypoints to reading/modfying the resource and know which condition variables to signal and when to do so.

## Atomic Instructions
CPU instructions that can be performed in a single step. For example checking and updating an important variable may cause issues if another thread updates it between the check and the subsequent step. If this can be done all at once, or atomically we avoid this problem.

## Anderson Performance of Spin Lock Alternatives Paper Summary
This paper discusses the performance impact of multiple processorsw ith shared memory using atomic `test_and_set` spin locks and suggests several alternatives.

The issue with `test_and_set` is that during the test phase the processors have to go directly to memory which is expensive. The paper proposes several alternatives such as `test_and_test_and_set` (do a non-atomic test of the lock's business first) and the expands on this by suggesting static delays (e.g. processor 1 would have 1 ms delay, processor 2 would have 2 ms delay, etc.) to avoid all processors freeing up at once and trying to acquire the lock.

Eventually it settles on a queue system as the most performant approach for long critical sections where all processors have access to a shared memory queue and track which one is next to try and acquire the lock.

**Link to paper:** [The Performance of Spin Lock Alternatives for Shared-Memory Multiprocessors](https://www.cc.gatech.edu/classes/AY2009/cs4210_fall/papers/anderson-spinlock.pdf)

## Resources
### Relevant OSTEP Chapters
Chapters 25-34 in [Operating Systems: Three Easy Pieces](http://pages.cs.wisc.edu/~remzi/OSTEP/#book-chapters) cover concurrency in general. I found the following chapters to be most relevant to CS6200:
* [Locks](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-locks.pdf)
* [Locked Data Structures](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-locks-usage.pdf)
* [Condition Variables](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-cv.pdf)
* [Semaphores](http://pages.cs.wisc.edu/~remzi/OSTEP/threads-sema.pdf)
