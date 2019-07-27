---
layout: post
type: note
title: "NP Problem Reduction Notes"
color: red-9009
icon: fa-exclamation
date: 2019-07-25
categories:
  - omscs
  - graduate algorithms
  - np complete
  - np hard
  - np reduction
description:
  "Quick notes on steps to reduce a known NP-Hard problem to a new problem of unknown difficulty"
---
Typed version of some of my notes on NP and NP-Complete reductions for the [Graduate Algorithms](https://www.omscs.gatech.edu/cs-8803-ga-graduate-algorithms) course I am taking. Attached at the bottom are various resources that I found helpful, so if you've stumbled upon this page somehow I recommend checking those out as well.

## NP Reduction Steps

To show that a new problem of unknown difficulty is NP-Complete we have to do two main things.

1. Show that the problem lies in NP.
1. Show that the problem is NP-Hard.

If the problem both lies in NP and is shown to be NP-Hard then we can consider it NP-Complete! 😌

## Show that the problem lies in NP

Showing that a problem lies in NP isn't too difficult. To do this we need to think back to our definition of NP. A problem lies in NP if you can verify a solution to the problem (**YES** or **NO**) in polynomial time _and_ you can solve the problem in **nondeterministic** polynomial time.

So what does this mean? Given a solution to the problem we need to show how we would verify it in polynomial time. Basically jot down the algorithm and do a quick runtime complexity analysis of it.

For example, to verify the [Independent Set problem](https://en.wikipedia.org/wiki/Independent_set_(graph_theory)#Maximum_independent_sets_and_maximum_cliques) where we are given a graph _G_, a candidate solution set _S_, and a target minimum set size _t_ we would do the following:

1. Check each pair of vertices in _S_ and verify there is no edge between them. For _n_ vertices in _S_ this would take _O(n<sup>2</sup>)_ time. 
1. Verify the size of _S_ is ≥ _t_. This would take _O(n)_ time.

As you can see, we can verify the Independent Set problem in polynomial time so it lies in the class NP.

## Show that the problem is NP-Hard

We can show that our new problem is NP-Hard by reducing another _known NP-Hard_ problem to it in polynomial time. If we can do this, it shows that our new problem is _at least as hard_ as the known problem. Let's refer to the known NP-Hard problem as _B_ and our new problem as _A_. Here are the high-level steps for reducing _B_ to _A_.

### Step 1 - Transform Input

Show that you can transform an input for _B_ into an input for _A_ in polynomial time. For [3-SAT](https://math.stackexchange.com/questions/86210/what-is-the-3-sat-problem) -> k-Independent Set (_k_ is our target _t_ and equal to the number of clauses in the 3-SAT input) this would look like converting a [CNF Formula](https://en.wikipedia.org/wiki/Conjunctive_normal_form) into a graph where the variables in the formula (and their negations) are vertices.

<div>
<img class="image-frame" src="https://images.downey.io/diagrams/3SAT-to-IndependentSet-2.png" alt="Convert CNF from 3SAT to graph for k-Independent Sets problem">
</div>

In the example above we create a triangle of vertices for each clause. We will choose to rely on satisfying a particular variable per clause by choosing it for our independent sets. To avoid accidentally relying on both a variable and its negation we connect these vertices with an edge. Since the definition of an independent set says that two vertices in the set cannot be connected by an edge, this inter-variable edge prevents us from choosing a contradicting set of assignments.

### Step 2 - Use Blackbox for Problem A

Pretend you have a working polynomial time algorithm that can solve your new problem _A_ and use it as a blackbox. Pass this algorithm your transformed input.

<div>
<img class="image-frame" src="https://images.downey.io/diagrams/3SAT-to-IndependentSet-1.png" alt="3SAT to Independent Sets reduction diagram">
</div>

### Step 3 - Transform Solution

Convert a solution to _A_ into a solution for _B_. For the 3-SAT to Independent Set reduction this would mean using the set of independent vertices to create true/false variable assignments. Show why **NO** results for _A_ also hold true for problem _B_.

<div>
<img class="image-frame" src="https://images.downey.io/diagrams/3SAT-to-IndependentSet-3.png" alt="Convert solution for k-Independent Sets problem to 3SAT solution">
</div>

In the example above, the vertices in our independent set correspond with the variables X<sub>3</sub> and _not_-X<sub>1</sub> which means those must be satisfied. Since we're not relying on X<sub>2</sub> and X<sub>4</sub> for anything they can be set to true or false, hence the wildcard.

### Step 4 - Provide Proof

1. Prove that if an arbitrary instance is **YES** for _B_, that it is also **YES** for _A_
1. Prove that if a reduced instance is **YES** for _A_, that is is also **YES** for _B_

For this last proof you need to show that all instances that are produced from our reduction algorithm are valid in both -- not arbitrary instances for _A_. By this I mean, the graphs we produce during the reduction are of a very particular structure. The Independent Set problem works on abritrary graphs of any structure and these don't necessarily go _A_ -> _B_.


## Additional Resources
* [P vs. NP and the Computational Complexity Zoo](https://www.youtube.com/watch?v=YX40hbAHx3s)
* [Algorithms by Jeff Erickson - Ch 12](http://jeffe.cs.illinois.edu/teaching/algorithms/book/12-nphard.pdf)
* [MIT 6.046J Design and Analysis of Algorithms Recitation 8](https://www.youtube.com/watch?v=G7mqtB6npfE)
