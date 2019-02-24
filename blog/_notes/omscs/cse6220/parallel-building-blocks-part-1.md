---
layout: post
type: note
title: "Pre-Midterm IHPC Concurrency Primitives"
color: green-9009
icon: fa-code-fork
date: 2019-02-23
categories:
  - ihpc
  - parallel building blocks
  - reduce
  - par-for
  - bitonic sort
  - parallel scans
description:
  "Notes on some of the concurrency 'primitives' discussed in the first half of the course."
---
These are some of the parallel algorithm "primitives" that are discussed in the first half of [the course](https://www.omscs.gatech.edu/cse-6220-intro-hpc) and used to solve some parallel programming problems. Some are more generic and some are pretty specialized. There's some ruby-esque pseudocode as well that I've adopted from the pseudocode in the lectures. This is all to help me prepare for the midterm exam, so if you've stumbled on this somehow I recommend just watching the lectures for yourself (I'll try and include links). Those should have better explanations.

All pseudocode examples will assume the presence of a `spawn` function for spawning a concurrent task and a `sync` function for blocking and waiting until all spawned tasks have finished.

## Contents
* [reduce](#reduce)
* [parallel for loop](#par-for)
* [bitonic split](#bitonic-split)
* [bitonic merge](#bitonic-merge)
* [bitonic sort](#bitonic-sort)
* [parallel scan](#parallel-scan)
* [gather if](#gather-if)
* [parallel root finding](#parallel-root-finding)



## Reduce
Reduce, also known as [fold](https://en.wikipedia.org/wiki/Fold_(higher-order_function)) provides a means of recursively processing a datastructure (e.g. array, list, etc.) and combining its constituents into a single result.

```ruby
def reduce(A[0:n-1])
    if n >= 2
        a = spawn(reduce(A[0:(n/2 - 1)]))
        b = spawn(reduce(A[(n/2):(n - 1)]))
        sync
        return a + b
    else # base case is a single element array
        return A[0]
```

* **W(n):**  _O(n)_
* **D(n):**  _O(log n)_
* **Lecture Link:** [Reduce](https://youtu.be/_bRruc7i5C4?t=287)

## Par-for
Par-for (i.e. for-any, for-all), or the parallel for loop, provides a means executing the iterations of a loop in parallel -- provided that all iterations are independent of each other. See the [OpenMP parallel loop docs](http://pages.tacc.utexas.edu/~eijkhout/pcse/html/omp-loop.html). You might think the span of a par-for loop would be constant, but since there is overhead around scheduling (spawning) the tasks, it actually results in a _O(log n)_ span. See the following pseudocode.

```ruby
# if you wanted to run the following loop in parallel
par_for 0..n do |i|
    foo(i)

# this really becomes something like:
par_for_impl(foo, 0, n)

def par_for_impl(func, first_idx, last_idx):
    n = last_idx - first_idx + 1
    if n == 1
        func(first_idx)
    else
        m = first_idx +  (n / 2)
        # divide and conquer to get that log(n)
        spawn par_for_impl(func, first_idx, m - 1)
        par_for_impl(func, m, last_idx)
        sync
```

* **W(n):**  _O(n)_
* **D(n):**  _O(log n)_
* **Lecture Link:** [par-for](https://youtu.be/_CLSFQA7HbI)

## Bitonic Split
When you pair the elements of a [bitonic sequence](https://en.wikipedia.org/wiki/Bitonic_sorter) such that each min is paired with the max. In other words the smallest is paired with the largest, the second smallest paired with the second largest, and so on so forth. Then you separate the mins and maxes from each pair into two separate subsequences. This helps enable the use of bitonic sequences in divide and conquer algorithms. [This site](https://www.cs.rutgers.edu/~venugopa/parallel_summer2012/bitonic_overview.html#bitonic_split) has a nice explanation as well.

```ruby
def bitonic_split(A[0:n-1])
    # assume n is evenly divisible by 2
    par_for 0..(n/2 - 1) do |i|
        a = A[i]
        b = A[i + n/2]
        A[i] = min(a, b)
        A[i + n/2] = max(a,b)
```

* **W(n):**  _O(n)_
* **D(n):**  _O(log n)_
* **Lecture Link:** [bitonic split](https://youtu.be/6v_D0X15jf0)

## Bitonic Merge
You can use the bitonic split defined above to divide and conquer an existing bitonic sequence to end up with a sorted sequence. See the following pseudocode:

```ruby
def bitonic_merge(A[0:n-1])
    # assume A is a bitonic sequence
    # assume n is evenly divisible by 2
    if n >= 2
        bitonic_split(A[:]) # split everything in A
        spawn(bitonic_merge(A[0:(n/2 - 1)]))
        bitonic_merge(A[(n/2):(n - 1)])
        sync
```

* **W(n):**  _O(n)_
* **D(n):**  _O(log n)_
* **Lecture Link:** [bitonic merge](https://youtu.be/9hE9YrnbfbY)

## Bitonic Sort
Now you can use bitonic split and bitonic merge together to generate a bitonic sequence out of an unordered sequence and sort it. This requires two modified versions of bitonic_merge -- bitonic_merge_asc and bitonic_merge_desc -- where one produces a positively ascending sequence and the other a negatively descending sequence.

```ruby
def gen_bitonic(A[0:n-1])
    # assume n is evenly divisible by 2
    if n >= 2
        spawn(gen_bitonic(A[0:(n/2 - 1)]))
        gen_bitonic(A[(n/2):(n - 1)])
        sync
        spawn(bitonic_merge_asc(A[0:(n/2 - 1)]))
        bitonic_merge_desc(A[(n/2):(n - 1)])
        sync


def bitonic_sort(A[0:n-1])
    gen_bitonic(A[:])
    bitonic_merge_asc(A[:])
```

* **W(n):**  _O(n log² n)_ (not work-optimal)
* **D(n):**  _O(log³ n)_
* **Lecture Link:** [bitonic sort](https://youtu.be/3535fVGDdq4)

## Parallel Scan
Scans are a generalization of the [prefix-sum](https://en.wikipedia.org/wiki/Prefix_sum) operation. Parallel scans allows us to apply any associate operator across a list in parallel. See the following pseudocode for the `add_scan` primitive that implements a parallel prefix-sum.

```ruby
# This pseudocode is pretty rough...
# definitely recommend watching the lectures for this one
def add_scan(A[1:n])
    # assume n = 2^k (power of two)
    # assume 1 indexed arrays ¯\_(ツ)_/¯
    if n == 1
        return A[1]
    else
        Iodds[1:n/2] ~= [1, 3, 5, ...] # odd indices
        Ievens[1:n/2] ~= [2, 4, 6, ...] # even indices

        A[Ievens] = par_for 1..(n/2) { |i| A[Ievens[i]] + A[Iodds[i]] }
        A[Ievens] = add_scan(A[Ievens])
        A[Iodds] = par_for 2..(n/2) { |i| A[Ievens[i]] + A[Iodds[i]] }
```

* **W(n):**  _O(n)_
* **D(n):**  _O(log² n)_
* **Lecture Link:** [parallel scans](https://youtu.be/OO3o14cINbo)

## Gather If
First construct an array of flags by applying a comparison in parallel across all elements of a list.

GatherIf takes this array of flags (trues and falses) and then uses an add scan to determine the indices of the elements that matched the condition. The following code shows how a `get_smaller_equal` method might work hand-in-hand with `gather_if` to return only the elements that are less than or equal to the `pivot` value. This can be useful in implementing a parallel quicksort.

```ruby
# again some nice 1-indexed array pseudocode :)

def get_smaller_equal(A[1:n], pivot)
    F[1:n] = [] # array of {0, 1} boolean flags
    F[:] = par_for { |i| A[i] <= pivot }
    gather_if(A[1:n], F[1:n])

def gather_if(A[1:n], F[1:n]):
    K[1:n] = [] # for indices of matching elements
    K[:] = add_scan(F[:])
    L[1:K[n]] = [] # output array size of largest prefix-sum
    par_for 1..n do |i|
        # Now, in parallel, for all true elements we put their value
        # in the corresponding index of the output array
        if F[i]
            L[K[i]] = A[i]
    return L[:]
```

* **W(n):**  _O(n)_
* **D(n):**  _O(log² n)_
* **Lecture Link:** [gatherIf](https://youtu.be/lJuo9wUZNy8)

## Parallel Root Finding
This uses a the idea of jumping from tree nodes -> grandparents to be able to find the root of a tree by starting at all of its leaves in parallel.

```ruby
# again some nice 1-indexed array pseudocode :)

def has_grandparent(k, P[1:n])
    # k is a node
    # Where P is an array indexed by k where values point
    # to the parent of k
    return (k != nil) && (P[k] > 0)
                      && (P[P[k]] > 0)

def adopt(P[1:n], G[1:n]):
    # P is again an array of parent pointers
    # G will be an array of grandparent pointers
    par_for 1..n do |i|
        if has_grandparent(i, P[:])
            G[i] = P[P[i]]
        else
            G[i] = P[i]

def find_roots(P[1:n], G[1:n]):
    Pcur[1:n] = P[:]
    Pnext[1:n] = [temp buf]
    for 1..ceil(log(n)) do |level|
        adopt(Pcur[:], Pnext[:])
        Pcur[:] = Pnext[:]
    R[:] = Pcur[:]
```

* **W(n):**  _O(n log n)_ (not work-optimal)
* **D(n):**  _O(log² n)_ (?)
* **Lecture Link:** [Parallel Root Finding](https://youtu.be/jtLuZC1XwxQ)
