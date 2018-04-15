---
layout: post
type: note
title: "Notes on OS Memory Management"
color: green-9009
icon: fa-code
date: 2018-04-15
categories:
  - operating systems
  - memory
  - page tables
description:
  "Notes on memory management -- page tables, segementation, TLB, etc."
---
This note will be **very** loosely structured -- it's just to help me organize my thoughts around how the (mainly Unix) OS manages memory and prepare for the final exam in CS6200.

## Relevant OSTEP Chapters
Chapters 12 - 24 in this book cover all things memory. I've cherry-picked a few that I believe to be particularly relevant to this particular class.
* [Short Introduction](http://pages.cs.wisc.edu/~remzi/OSTEP/dialogue-vm.pdf)
* [Address Spaces](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-intro.pdf)
* [Memory API](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-api.pdf)
* [Address Translation](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-mechanism.pdf)
* [Introduction to Paging](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-paging.pdf)
* [Translation Lookaside Buffers](http://pages.cs.wisc.edu/~remzi/OSTEP/vm-tlbs.pdf)

