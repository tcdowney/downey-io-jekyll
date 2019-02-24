---
layout: post
type: note
title: "Work Span Analysis Notes"
color: vapor-wave-purple
icon: fa-code-fork
date: 2019-02-17
categories:
  - high performance computing
  - work
  - span
  - DAG
  - brent's theorem
description:
  "Notes on work and span lectures"
---
Some loosely structured notes on the [IHPC](https://www.omscs.gatech.edu/cse-6220-intro-hpc) "Work and Span" lectures to help me prepare for the midterm. Explaining things in my own words helps me focus on the material and gives me a searchable artifact to find later. The contents of this one probably won't be that useful for others though and there's a lot of messily written non-LaTeX equations. I recommend checking out the [official notes](https://s3.amazonaws.com/content.udacity-data.com/courses/gt-cse6220/Course+Notes/Lesson1-1+Introduction+(1).pdf) for this section.

## Work Span Analysis
Formalism for analyzing parallel algorithms

**Work** _W(n)_
* Total number of vertices (work) in a DAG ([directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph))

**Span** _D(n)_ (_D_ represents _depth_)
* Total number of vertices in the longest path through a DAG

The average available parallelism for an algorithm can be represented by W(n)/D(n).

**Span Law**
* Tp(n) >= D(n)

The time to execute given _p_ processors is greater than or equal to the span of the algorithm.

**Work Law**
* Tp(n) >= ceil(W(n)/p)

The time to execute given _p_ processors is greater than or equal to the work of the algorithm divided by the number of processors. Ceiling cause we're dealing with integers.

**Work-Span Law**
* Tp(n) >= max(D(n), ceil(W(n)/p))

Both laws hold so can be combined. Simply take the max of the two! :)

## Brent's Theorem
The Work-Span Law gives us a lower bound for the time to execute a parallel algorithm. Brent's Theorem helps us find the upper bound! 👋 😳 👍
The paper describing this theorem can be found [here](https://maths-people.anu.edu.au/~brent/pd/rpb022.pdf).

**Brent's Theorem**
* Tp(n) <= (W(n) - D(n))/p + D(n)

The time to execute the DAG is no more than the time to execute the critical path (longest path -- the span) plus the time to schedule the rest of the work across the _p_ processors.

**Putting it all together...**
* max(D(n), ceil(W(n)/p)) <= Tp(n) <= (W(n) - D(n))/p + D(n)

## Speedup & Work-Optimality
How much faster the parallel algorithm is compared to the best sequential time. Linear speedup means Tp scales linearly with the number of available processors. **Note:** the * in W*(n) denotes the work of the best sequential algorithm.

**Speedup**
* speedup = best sequential time / parallel time

* Sp(n) = W*(n) / Tp(n) >= p / (W(n)/W*(n) + (p - 1)/(W*(n) / D(n)))

**Work-Optimality**
* W(n) / W*(n) should hopefully equal 1

If you get a highly parallel algorithm by dramatically increasing the work relative to the best sequential algorithm, this is bad for speedup.

## Master Theorem
I found [this video](https://www.youtube.com/watch?v=T68vN1FNY4o) helpful.
