---
layout: post
type: blog
title: "The Helman and JáJá List Ranking Algorithm"
sub_title: "a simpler explanation"
color: teal
icon: fa-list-ol 
date: 2019-05-15
categories:
  - helman-jaja list ranking
  - list ranking
  - parallel algorithms
  - ihpc
  - omscs
excerpt: "In one of our labs in Georgia Tech's Intro to High Performance Computing course, we had to explore the parallel computing problem of list ranking. List ranking is essentially just traversing a linked list and assigning each node a \"rank\", or distance from the list's head. This post explores two parallel algorithms for list ranking -- Wylies's and Helman-Jájá."
description:
  "An illustrated explanation of the Helman and Jájá list ranking algorithm."
---

<div>
<img src="https://images.downey.io/blog/dec-pdp-10.jpg" alt="DEC PDP 10 computer">
</div>

In one of our labs in Georgia Tech's [Intro to High Performance Computing](https://www.omscs.gatech.edu/cse-6220-intro-hpc) course, we had to explore the parallel computing problem of [list ranking](https://en.wikipedia.org/wiki/List_ranking). This [lecture](https://www.youtube.com/watch?v=0m1VOexMhlw) by Professor Vuduc does a better job explaining than I can, but list ranking is essentially just traversing a linked list and assigning each node a "rank", or distance from the list's head. A serial implementation of list ranking is trivial and can be completed in _O(n)_ time by walking the list. A parallel implementation is a bit trickier. In our lab we researched and implemented two such algorithms: Wyllie's and Helman/JáJá's. I found Wyllie's algorithm to be easy enough to grok, but Helman and JáJá's was a different story. It felt like there was a dearth of simple explanations for the algorithm outside of academic papers so this post is my attempt at rectifying that.

## Array Pool Representation of Linked Lists

To operate on and access a linked list in parallel we need to rethink our representation of it. It can't simply be a loose collection of node that contain pointers to each other since there is no way of discovering/accessing the nodes out of order that way. Instead, we need to represent the linked list using an array. Professor Vuduc refers to this as an [array pool](https://www.youtube.com/watch?v=M4Zsh5OuB5Y) representation. I found this naming confusing at first since it made me think of an [object pool](https://en.wikipedia.org/wiki/Object_pool_pattern) consisting of a bunch of arrays. It's not that, though. It's a pool of list nodes that just happens to be represented by an array. Regardless of the naming, using an array pool let's us represent a linked list using a single contiguous piece of memory. Consider the arrays below:

<div>
<img class="image-frame" src="https://images.downey.io/diagrams/helman-jaja-5.png" alt="Array Pool representation of a linked list">
</div>

The `Successors` array represents the "next" pointers for each node in a linked list and each "next" pointer corresponds with an index in the array. The `List Ranks` array represents the "value" for each node in the linked list at a given index. Or in other words, `Successors[0]` and `List Ranks[0]` both refer to the same logical linked list node, they just contain different attributes of the node.

To make it easier to visualize, in the example above each node has its list rank as its value. In practice, however, a node's value could be anything. For the algorithm descriptions that follow we will assume our implementation is using an array pool to represent the list.

## Glossary
I will be using the following variables throughout:

* **_P_ -** Number of processors
* **_n_ -** Number of nodes in the list
* **_s_ -** Number of sublists

## Wyllie's List Ranking Algorithm

Wyllie's algorithm takes a divide-and-conquer approach by continuously splitting the list into smaller sublists via a technique known as pointer jumping. [This lecture](https://youtu.be/WWst31ORiDI) does a good job of explaining the algorithm and there are lots of resources online so I won't go into too much detail. In terms of [work and span analysis](https://en.wikipedia.org/wiki/Analysis_of_parallel_algorithms), Wyllie's algorithm has a span of _O(log<sup>2</sup>n)_ and work of _O(nlogn)_. As you can see, it has to do significantly more work than the serial algorithm so you need to have a large value of `n` and a high amount of available processors to make Wyllie's approach worthwhile. This is where Helman and JáJá's algorithm comes in.

## Helman and JáJá's List Ranking Algorithm

Helman and JáJá describe their approach to the list ranking problem with a span of _O(n/P)_ and work of _O(n)_ in their paper [Designing Practical Efficient Algorithms for Symmetric Multiprocessors](https://www.cc.gatech.edu/~bader/COURSES/UNM/ece638-Fall2004/papers/HJ99.pdf) (for more information on the performance analysis of the algorithm I recommend checking out [this paper](https://pdfs.semanticscholar.org/f95a/7864e95184180a6b55357149b3712b5aa73f.pdf)). I found their paper pretty dense, however, and realized that there was a lack of approachable explanations for it online. Here's my attempt at explaining it step-by-step.

### Split the List into Sublists

Split the linked list into sublists by randomly choosing at least _P - 1_ **sublist heads** in addition to the list's true head to create _s_ sublists. This in theory will allow us to divide up sequential list-ranking of each sublist across the _P_ processors. However, since we're randomly choosing sublist heads there is the potential for the work to be distributed unevenly. So, in practice, I actually saw improved performance by choosing a value of _s_ that was greater than _P_ and allowing [OpenMP](https://www.openmp.org/) to sort of load balance the work across the processors. In the diagram below we're randomly selecting 2 sublist heads (indices 6 and 8) in addition to the list's true head (index 2):

<div>
<img class="image-frame" src="https://images.downey.io/diagrams/helman-jaja-1.png" alt="Random sublist head selection">
</div>

### Traverse Each Sublist in Parallel and Compute Partial List Rankings

Now, in parallel, we can traverse each sublist -- stopping when we reach the head of another sublist. In the diagram below, consider the green, blue, and orange traversals to be occurring on distinct processors.

<div>
<img class="image-frame" src="https://images.downey.io/diagrams/helman-jaja-2.png" alt="Sublist traversal of an array pool linked list">
</div>

While walking these sublists, we sequentially compute the list ranking for the sublist on each processor. After we're done, we should have these partial rankings in our `List Ranking` array. Whenever we reach the end of a sublist we record the total rank of our current sublist and the index of the next sublist's head for use in the next step. See the diagram below for what the current state of our `List Ranking` array will look like:

<div>
<img class="image-frame" src="https://images.downey.io/diagrams/helman-jaja-3.png" alt="Partial list rankings for sublists">
</div>

### Sequentially Compute the List Rankings of the Sublist Heads
As mentioned earlier, we should have recorded the total rank for each sublist along with the index of the head of the following sublist. We can use that data to sequentially compute the starting rank offsets for each sublist.

<div>
<img class="image-frame" src="https://images.downey.io/diagrams/helman-jaja-6.png" alt="Sequentially Compute the List Rankings of the Sublist Heads">
</div>

As you can see in the diagram above, we can walk across the sublist heads themselves in the correct order since we recorded each sublist's successor index. Since we recorded the total rank as well for each sublist we can just accumulate these values using a [prefix sum](https://en.wikipedia.org/wiki/Prefix_sum) operation.

### Apply the Sublist Head Rank Offsets in Parallel
Now, in parallel, we can apply the rank offsets we computed for each sublist head to all of the nodes in each sublist. The diagram below demonstrates what this might look like:

<div>
<img class="image-frame" src="https://images.downey.io/diagrams/helman-jaja-4.png" alt="Apply rank offsets across sublist nodes in parallel">
</div>

If you've done some basic bookkeeping to track which sublist a node belongs to, this can be done as a massively parallel operation using a simple `parallel for` loop across all of the elements at once. As you can see in the diagram above, this results in the `List Ranks` array containing the final list ranking values for the linked list.

## Other Resources
Hopefully you found this explanation helpful. If you're still stumped, the following resources helped me during implementation.

1. [Designing Practical Efficient Algorithms for Symmetric Multiprocessors (excerpt from original Helman and Jájá paper)](https://www.cc.gatech.edu/~bader/COURSES/UNM/ece638-Fall2004/papers/HJ99.pdf)
2. [A Comparison of the Performance of List Ranking and
Connected Components Algorithms on SMP and MTA
Shared-Memory Systems](https://pdfs.semanticscholar.org/f95a/7864e95184180a6b55357149b3712b5aa73f.pdf)
3. [List Ranking on Multicore Systems](https://eprints.ucm.es/11387/1/HugoDocument.pdf)

If you have any suggestions or feedback for this post feel free to [create an issue](https://github.com/tcdowney/downey-io-jekyll/issues). And always remember, dream big!

<div>
<img src="https://images.downey.io/blog/dream-big.jpg" alt="Dream Big coin in front of Rocky Balboa statue">
</div>
