---
layout: post
type: note
title: "Graphs - Minimum Spanning Trees and Kruskal's Algorithm"
sub_title: "a look into minimum spanning trees, kruskal's algorithm, and the cut property"
color: vapor-wave-purple
icon: fa-map-signs
date: 2019-06-16
categories:
  - graduate algorithms
  - graph theory
  - minimum spanning tree
  - mst
  - kruskal algorithm
  - cut property
description:
  "Notes covering minimum spanning trees, Kruskal's algorithm, the cut property, and resources I found helpful"
---
I wrote this up to help solidify my own understanding of minimum spanning trees and Kruskal's algorithm for the [algorithms course](https://www.omscs.gatech.edu/cs-8803-ga-graduate-algorithms) I'm currently taking. Explaining things in my own words helps me learn and explaining it differently from what's already out there may help someone else. 😌 In this post I'll explain what minimum spanning trees are, include some examples, do a walkthrough of Kruskal's algorithm, and try my best at explaining the cut property. At the end I'll include some additional resources that I find helpful.

## What is a Minimum Spanning Tree

A [minimum spanning tree](https://en.wikipedia.org/wiki/Minimum_spanning_tree) of a weighted undirected graph is a subgraph that meets the following properties:

1. All vertices of the graph remain connected
2. There are no cycles in the graph
3. Total edge weight is minimized

Let's consider the following graph _G_:

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-plain.png" alt="Graph G with 7 verticies">
</div>

As you can see, _G_ is an undirected graph with weights on all edges. Now let's look at some examples of subgraphs that are **not** minimum spanning trees.

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-non-mst.png" alt="Two invalid minimum spanning trees for graph G">
</div>

First lets look at T<sup>1</sup> on the left. Is this a spanning tree? Yes it is because the subgraph (denoted by lines highlighted in red) does not contain any cycles! Imagine you grabbed vertex C and let the other vertices hang freely. This might look like the following:

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-t1-dangling.png" alt="A 'dangling' incorrect MST for T1">
</div>

See how it forms a tree structure?

By contrast, T<sup>2</sup> is **not** a spanning tree because it contains a cycle between vertices A, B, C, and D. If we grab C on this one, notice how all the edges hang taut except for the cycular edges that tie B and D back to A.

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-t2-dangling.png" alt="A 'dangling' incorrect MST for T2">
</div>

So T<sup>2</sup> is not a spanning tree so it clearly cannot be a minimum spanning tree. How come T<sup>1</sup> isn't? Well it violates our third property of minimizing total edge weight. T<sup>1</sup> uses two of the most expensive edges of weight 4 to construct its tree when there are cheaper alternatives. So what do the minimum spanning trees for this _G_ actually look like?

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-good-mst.png" alt="Two correct minimum spanning trees for graph G">
</div>

Both T<sup>3</sup> and T<sup>4</sup> meet all of our criteria by connecting all of the vertices, not containing any cycles, and minimizing total edge weight. We can visualize the tree structure by doing the same exercise as before and hoisting up the C vertex for T<sup>3</sup> as shown below:

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-t3-dangling.png" alt="A 'dangling' correct MST for T3">
</div>

That's cool. So how can we programmatically find a minimum spanning tree from a graph? One way is by using Kruskal's algorithm.

## Kruskal's Algorithm for Finding Minimum Spanning Trees
Kruskal's algorithm is a [greedy algorithm](https://en.wikipedia.org/wiki/Greedy_algorithm), meaning that we'll be making the most optimal choice locally for each subgraph as we work towards finding a minimum spanning tree for our graph _G_.
We'll be doing the following:

1. Sort the edges (_E_) of _G_ by weight
2. Gradually add in edges, smallest first, to connect components without introducing a cycle
3. Repeat the process above until we run out of edges or only a single connected component remains (the minimum spanning tree). If we run out of edges then the graph is not connected so there is **no minimum spanning tree** for it.

Sounds pretty simple, right? The trickiest bit in my opinion is this portion: _connect components without introducing a cycle_. We can do this by using something called a [union-find datastructure](https://www.youtube.com/watch?v=ibjEGG7ylHk). The linked video does a great job of explaining how it works, but in essence it will allow us to track which vertices are members of which connected components.

We'll start by adding all vertices to the union-find as their own component, and as we add in edges we will gradually merge (or union) components. The way this will work is as follows:

1. When considering an edge _e_ first do a _find_ using the union-find datastructure on the two vertices _u_ and _w_ connected by _e_. If _find(u)_ and _find(w)_ return the same result then both vertices are already members of the same component and adding this edge will introduce a cycle. In this case we cannot add _e_.
2. If _find(u)_ and _find(w)_ return different results then these two vertices are not currently connected and _e_ is a valid candidate edge. We then perform _union(u,v)_ on the vertices to union their components in the union-find. The next time we call _find(u)_ and _find(w)_ we will get the same result since they share a component.

Now assuming we have a sweet union-find at our disposal, let's walk through Kruskal's algorithm for our graph _G_.

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-plain.png" alt="Graph G with 7 verticies">
</div>

First let's sort our edges by weight:

* **A-B:** 1
* **A-D:** 1
* **F-G:** 1
* **B-C:** 2
* **D-C:** 2
* **E-G:** 2
* **E-C:** 3
* **A-C:** 4
* **C-G:** 4

Now we'll go over these edges in order, first looking at A-B.

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-kruskal-a-b.png" alt="Adding the A-B edge in Kruskal's algorithm">
</div>

It's our first edge so there definitely won't be a cycle here, but we'll check our union-find just to be sure. _find(A)_ and _find(B)_ confirm our suspicions that these vertices are not connected yet, so we can _union(A,B)_ and create our first connected component colored in blue.

Next we'll look at A-D. We run _find(A)_ and _find(D)_ and see that these are separate components hence no cycle! Let's add D to the blue component.

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-kruskal-a-d.png" alt="Adding the A-D edge in Kruskal's algorithm">
</div>

Next we check out edge F-G and _find(F)_ and _find(G)_ shows that these two vertices are not currently connected. We run _union(F,G)_ to form the orange component.

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-kruskal-f-g.png" alt="Adding the F-G edge in Kruskal's algorithm">
</div>

Now we're out of weight 1 edges so let's move on to the weight 2 edges. We take a look at edge B-C and add it to the blue component that B is a member of using the same process as before.

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-kruskal-b-c.png" alt="Adding the B-C edge in Kruskal's algorithm">
</div>

Now let's take a look at D-C. Here's where things get a bit interesting. When we run _find(D)_ and _find(C)_ we get the same result for both since they're both already members of the blue component. Adding in the edge from D-C will just add another way to connect these **already connected** vertices and introduce a cycle. Since spanning trees cannot contain cycles this is a no go.

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-kruskal-d-c.png" alt="Adding the D-C edge in Kruskal's algorithm">
</div>

Moving on to look at edge E-G we find that E and C are not already in the same component so we can _union(E,G)_ and join them together as part of the orange component.

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-kruskal-g-e.png" alt="Adding the E-G edge in Kruskal's algorithm">
</div>

We've now exhausted the weight 2 edges. Time to look at our weight 3 edge from E-C. If we run _find(E)_ and _find(C)_ we will see that these vertices are members of different components (orange and blue) so we can include the E-C edge to connect them. We've now joined our blue and orange components and have just a single component left! This means we've found our minimum spanning tree T<sup>3</sup>.

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-kruskal-e-c.png" alt="Adding the E-C edge in Kruskal's algorithm">
</div>

## Cut Property
A cut of a graph is a partitioning of the graph into two groups S and the set of of vertices not in S (the complement of S), S̅. The image below shows what these cuts might look like for our graph _G_.

<div>
<img src="https://images.downey.io/minimum-spanning-tree/mst-graph-g-cut-property.png" alt="Two cut components in the graph G">
</div>

The Cut Property states that any minimum weight edge across a cut must be part of _some_ minimum spanning tree for the graph. You can kind of intuit this for our example. We can choose either the edge **B-C** or **D-C** (both are equal weight) and this will lead to one of our minimum spanning trees T<sup>3</sup> or T<sup>4</sup>.

Erik Demaine's [lecture on Minimum Spanning Trees](https://youtu.be/tKwnms5iRBU?t=1765) has a good proof of the Cut Property at around the 30-minute mark.

## Additional Resources
Hopefully you've found this walkthrough of Kruskal's algorithm to be helpful. If you'd like to go deeper or just to have it explained in additional ways, I personally found the following lectures, videos, and papers really useful:

1. [Erik Demaine's Minimum Spanning Tree lecture](https://www.youtube.com/watch?v=tKwnms5iRBU)
2. [Josh Hug's video on the Cut Property](https://www.youtube.com/watch?v=QYdZS4S-FyU)
3. [William Fiset's video on the Union-Find Datastructure](https://www.youtube.com/watch?v=ibjEGG7ylHk)
4. [William Fiset's walthrough for Kruskal's Algorithm](https://www.youtube.com/watch?v=JZBQLXgSGfs)
5. [University of Toronot Cut Property handout](http://www.cs.toronto.edu/~vassos/teaching/c73/handouts/cut-property.pdf)
