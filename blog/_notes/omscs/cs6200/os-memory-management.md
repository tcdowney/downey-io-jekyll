---
layout: post
type: note
title: "Notes on Memory Management by Operating Systems"
color: green-9009
icon: fa-code
date: 2018-04-15
categories:
  - operating systems
  - memory management
  - page tables
description:
  "Notes on memory management -- page tables, segmentation, TLB, etc."
---
This note will be **very** loosely structured -- it's just to help me organize my thoughts around how the (mainly Unix) OS manages memory and prepare for the final exam in CS6200.

## Segmentation
* Arbitrarily sized blocks of memory
* Typically correspond to logical pieces of a process's memory, e.g. stack, heap, program code, etc.
* Segment descriptor + offset can be used to look up the physical memory address from the a segment descriptor table
* Most modern operating systems just use paging, but might support segmentation for backwards compatibility

## Page Tables
tbd

## Hierarchical Page Tables
tbd

## Translation Lookaside Buffer (TLB)
The Translation Lookaside Buffer, or TLB, is part of the hardware Memory Management Unit (MMU) that speeds of address translation. It is essentially just a cache for frequently translated addresses.

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
