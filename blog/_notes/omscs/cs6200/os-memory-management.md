---
layout: post
type: note
title: "Notes on Memory Management in Operating Systems"
color: green-9009
icon: fa-code
date: 2018-04-15
categories:
  - operating systems
  - memory management
  - page tables
description:
  "Notes on OS memory management -- flat vs. hierarchichal page tables, swap usage, segmentation, TLB, etc."
---
This note will be **very** loosely structured -- it's just to help me organize my thoughts around how the (mainly Unix) OS manages memory and prepare for the final exam in CS6200.

## Segmentation
* Arbitrarily sized blocks of memory
* Typically correspond to logical pieces of a process's memory, e.g. stack, heap, program code, etc.
* Segment descriptor + offset can be used to look up the physical memory address from the a segment descriptor table
* Most modern operating systems just use paging, but might support segmentation for backwards compatibility

## Page Tables
Table containing mappings of virtual memory addresses to physical memory addresses. Not all virtual addresses necessarily map to an actual page in physical memory at all times, and when such an address is accessed a [Page Fault exception](https://en.wikipedia.org/wiki/Page_fault) will occur. Usually this is fine and the OS just needs to allocate physical memory for the page. If the request is truly invalid, this typically results in a segmentation fault and the program is terminated.

## Hierarchical Page Tables
Processes typically do not use all of their available virtual address space -- typically just the top and the bottom addresses for their stack and heap. A flat page table would consume a lot of memory which would be mostly used to store unused addresses.

For example, in a 64 bit OS using 4kb pages a single process would need 36 petabytes of memory just for its page table. Math:

* 8 bytes per page table entry
* Number of virtual page numbers = 2^64 (address space size) / 4096 (page size in bytes)
* (2^64 / 4096) * 8 bytes = 36 petabytes

For this reason, OSes use hierarchical (aka multi-level) page tables that are a sort of tree-like structure. Memory addresses include indexes to traverse these page table trees and unused memory addresses no longer need to consume space in the page table and can be omitted.

[This video has a good explanation of hierarchical page tables](https://www.youtube.com/watch?v=8kBPRrHOTwg).

## Translation Lookaside Buffer (TLB)
The Translation Lookaside Buffer, or TLB, is part of the hardware Memory Management Unit (MMU) that speeds of address translation. It is essentially just a cache for frequently translated addresses.

## Copy on Write (COW)
[Copy on Write](https://en.wikipedia.org/wiki/Copy-on-write), or COW, is an optimization technique that lets forked processes continue using the virtual address space of their parent process and delay copying memory into a new virtual address space until they need to write to memory. This speeds up process creation and reduces the amount of memory/virtual address spaces necessary.

## Demand Paging
Since physical memory is scarce, [Demand Paging](https://en.wikipedia.org/wiki/Demand_paging) is a method of conserving it and only moves a page onto physical memory when a process first demands it. When it is no longer actively used, the page might be swapped back to disk.

[Page replacement algorithms](https://en.wikipedia.org/wiki/Page_replacement_algorithm) are used to determine when to swap pages back to disk. Once such policy an algorithm might use is the [Least Recently Used](https://en.wikipedia.org/wiki/Page_replacement_algorithm#Least_recently_used) (LRU) policy. Here, an "access" bit is incremented whenever a page is accessed and less accessed pages are swapped to disk. Some versions of Linux use the [Second Chance](https://en.wikipedia.org/wiki/Page_replacement_algorithm#Second-chance) algorithm.

## Resources
### Relevant OSTEP Chapters
Chapters 12 - 24 in [Operating Systems: Three Easy Pieces](http://pages.cs.wisc.edu/~remzi/OSTEP/#book-chapters) cover all things memory. I've cherry-picked a few that I believe to be particularly relevant to this particular class.
* [Short Introduction](http://pages.cs.wisc.edu/~remzi/OSTEP/dialogue-vm.pdf)
* [Address Spaces](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-intro.pdf)
* [Memory API](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-api.pdf)
* [Address Translation](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-mechanism.pdf)
* [Introduction to Paging](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-paging.pdf)
* [Translation Lookaside Buffers](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-tlbs.pdf)

### Other Resources
* [Stack Overflow - Why Use Hierarchical Page Tables?](https://stackoverflow.com/questions/9834542/why-using-hierarchical-page-tables)
* [Wikipedia - Page Tables](https://en.wikipedia.org/wiki/Page_table#Multilevel_page_table)
* [Cornell CS4410 Page Table Notes](http://www.cs.cornell.edu/courses/cs4410/2015su/lectures/lec14-pagetables.html)
