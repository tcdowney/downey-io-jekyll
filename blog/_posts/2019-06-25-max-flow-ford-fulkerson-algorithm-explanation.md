---
layout: post
type: blog
title: "Finding Max Flow using the Ford-Fulkerson Algorithm and Matthew McConaughey"
sub_title: "a step-by-step explanation"
color: red-9009
icon: fa-random
date: 2019-06-25
categories:
  - graduate algorithms
  - graph theory
  - max flow
  - min cut
  - ford-fulkerson
excerpt: "The max flow problem is an optimization problem for determining the maximum amount of 'stuff' that can flow at a given point in time through a single source/sink flow network. A flow network is essentially just a directed graph where the edge weights represent the flow capacity of each edge. The 'stuff' that flows through these networks could be literally anything. Maybe it's traffic driving through a city, water flowing through pipes, or bits traveling across the information superhighway. This post walks through how to use the Ford-Fulkerson to determine the max flow of a network."
description:
  "A few examples that walk through the Ford-Fulkerson algorithm for finding Max Flow through a flow network graph. Now including the wise words of Matthew McConaughey."
---

<div class="video-wrapper">
<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/aq5ecBaOb6Y" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Prereqs

Before reading further, make sure to watch the necessary prerequisite lecture by Matthew McConaughey above. His words of wisdom are the key to all of this.

## What is the Max Flow Problem?

The [max flow problem](https://en.wikipedia.org/wiki/Maximum_flow_problem) is an optimization problem for determining the maximum amount of _stuff_ that can flow at a given point in time through a single source/sink [flow network](https://en.wikipedia.org/wiki/Flow_network). A flow network is essentially just a directed graph where the edge weights represent the flow capacity of each edge. The _stuff_ that flows through these networks could be literally anything. Maybe it's traffic driving through a city, water flowing through pipes, or bits traveling across the internet.

To make this more concrete, let's look at the following example:

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-1.png" alt="Simple flow network">
</div>

This is a pretty simple graph with no back edges where _s_ is the source vertex and _t_ is the sink. Let's imagine that _s_ is a water treatment facility and _t_ is our home and we're interested in finding out the amount of water that can flow through to our literal bathroom sink.

You can kind of eyeball this one and see that although the edges coming out of the source (vertex _s_) have a large capacity, we're bottlenecked by the edge leading to our home (the sink vertex _t_) which can only transport 1 unit of water.

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-2.png" alt="Max flow path drawn across simple flow network">
</div>

Here our flow can clearly be at most the capacity of our smallest edge leading into _t_. So can we simply look for the smallest capacity edges and say definitively that we know our maximum flow? Almost... and we'll get to that later with the [max-flow min-cut theorem](https://en.wikipedia.org/wiki/Max-flow_min-cut_theorem), but first let's look at a more difficult example that has multiple edges flowing into the sink.

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-3.png" alt="Simple flow network for tutorial">
</div>

The flow network above is a bit of a classic example of this problem. We have four vertices and three paths from _s_ to _t_. Let's imagine we have the following greedy algorithm to discover the max flow for this graph:

1. Initially set the flow along every edge to 0.

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-4.png" alt="Simple flow network for tutorial initial zero flow">
</div>

2. Use a pathfinding algorithm like depth-first search (DFS) or breadth-first search (BFS) to find a path _P_ from _s_ to _t_ that has available capacity.
3. Let _cap(P)_ indicate the maximum amount of stuff that can flow along this path. To find the capacity of this path, we need to look at all edges _e_ on the path and subtract their current flow, _f<sub>e</sub>_, from their capacity _c<sub>e</sub>_. We'll set _cap(P)_ to be equal to the smallest value of _c<sub>e</sub>_ - _f<sub>e</sub>_ since this will bottleneck the path.
4. We then **augment the flow** across the edges in the path _P_ by our _cap(P)_ value.
5. Repeat the process from step 2 until there are no paths left from _s_ to _t_ that have available capacity.

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-5.png" alt="Simple flow network naive algorithm results">
</div>

Using the naive greedy algorithm described above on our flow network will result in a suboptimal flow of 3. However, with the two edges entering _t_ having capacities of 2 and 3, it really feels like we should be able to achieve a max flow of 5. The graph below shows how we can achieve this by being just a bit smarter with our flow allocations.

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-6.png" alt="Simple flow network true max flow results">
</div>

How can we do this though? This is where the wisdom of Matthew McConaughey comes in.

_**"Sometimes you've got to go back to actually move forward."**_

## The Residual Graph

Imagine if we could look back at the choices we've made and undo some of our earlier flow decisions. Turns out we can using something called the residual graph. This is what Matthew was referring to all along.

We'll basically take our existing graph and update the capacities of all the regular edges to be the current remaining capacity (_c<sub>e</sub>_ - _f<sub>e</sub>_). We'll then add back edges indicating the amount of flow currently going across this edge. We can then use that back edge to decrease flow in order to try out alternate flow allocations. The graph below shows the residual graph that results after running our original algorithm.

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-7.png" alt="The residual graph for the tutorial flow network">
</div>

With a few tweaks to our algorithm, we can use the concept of a residual graph to find the true maximum flow in our network. This is known as the [Ford-Fulkerson algorithm](https://en.wikipedia.org/wiki/Ford%E2%80%93Fulkerson_algorithm).

## The Ford-Fulkerson Algorithm
This algorithm will look pretty similar to the one we laid out earlier, with one key difference. We will be constructing a residual graph for the flow network and searching for _s-t_ paths across it instead!

1. Initially set the flow along every edge to 0.
2. Construct a residual graph for this network. It should look the same as the input flow network.

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-8.png" alt="Ford Fulkerson walkthrough initial">
</div>

3. Use a pathfinding algorithm like depth-first search (DFS) or breadth-first search (BFS) to find a path _P_ from _s_ to _t_ that has available capacity **in the residual graph**.
4. Let _cap(P)_ indicate the maximum amount of stuff that can flow along this path. To find the capacity of this path, we need to look at all edges _e_ on the path and subtract their current flow, _f<sub>e</sub>_, from their capacity _c<sub>e</sub>_. We'll set _cap(P)_ to be equal to the smallest value of _c<sub>e</sub>_ - _f<sub>e</sub>_ since this will bottleneck the path.
5. We then **augment the flow** across the forward edges in the path _P_ by adding _cap(P)_ value. For flow across the back edges in the residual graph, we subtract our _cap(P)_ value.
6. Update the residual graph with these flow adjustments.
7. Repeat the process from step 2 until there are no paths left from _s_ to _t_ in the **residual graph** that have available capacity.

Let's step through this for our example graph.

### Step 1
Initial flow is set to 0.

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-8.png" alt="Ford Fulkerson walkthrough initial">
</div>

### Step 2
Run through the algorithm once and find we can achieve a flow of 3. Update the residual graph.

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-9.png" alt="Ford Fulkerson walkthrough first round">
</div>

### Step 3
Search through the updated residual graph for a new _s-t_ path. There are no forward edges available anymore, but we can use a back edge to augment the current flow. We can decrease the flow along the A-B edge by 2 which will allow us to make use of both edges leading into _t_!

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-10.png" alt="Ford Fulkerson walkthrough path through back edge">
</div>

### Step 4
Augment the current flow with our findings above and update the residual graph.

<div>
<img class="image-frame" src="https://images.downey.io/max-flow/max-flow-11.png" alt="Ford Fulkerson walkthrough complete results">
</div>

There are now no edges with available capacity that we can use to create a path from _s_ to _t_. This means our run of the Ford-Fulkerson algorithm is complete and our max flow leading into _t_ is 5!

## Summary
That was a pretty trivial example, so I would like to reiterate that the Ford-Fulkerson algorithm can be used to find the max flow of _much_ more complicated flow networks. Provided that they have positive integers as capacities, of course.

I highly recommend watching [William Fiset's video explanation](https://www.youtube.com/watch?v=LdOnanfc5TM) to see an example of the algorithm run against one of these larger networks. Apart from that video, if you'd like to go deeper or just to have it explained in additional ways, I personally found the following lectures, videos, and notes really useful:

1. [CMSC Network Flows notes](https://www.cs.cmu.edu/~ckingsf/bioinfo-lectures/netflow.pdf)
2. [William Fiset's Ford Fulkerson source code video](https://www.youtube.com/watch?v=Xu8jjJnwvxE)
3. [Tim Roughgarden's Intro to Max Flow lecture](https://www.youtube.com/watch?v=dorq_YA6plQ)

Also, if your graph doesn't have integer capacities or if you want to explore a potentially faster method of finding max flow, I recommend looking into the [Edmonds-Karp algorithm](https://www.youtube.com/watch?v=OViaWp9Q-Oc).

Best of luck on your algorithmic journey!
