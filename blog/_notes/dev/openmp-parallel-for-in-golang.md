---
layout: post
type: note
title: "Emulating an OpenMP Parallel For-Loop in Go"
sub_title: "Using Goroutines to create OpenMP-style par-for loops in Golang"
color: green
icon: fa-code
date: 2019-05-08
categories:
  - golang
  - par-for golang
  - openmp go
  - parallel for-loop go
description:
  "How to use goroutines to implement an OpenMP-style parallel for-loop in the Go programming language."
---
In several of the labs for Georgia Tech's [Intro to High Performance Computing](https://www.omscs.gatech.edu/cse-6220-intro-hpc) course we used [OpenMP](https://www.openmp.org/) and C to implement some parallel algorithms. Although C can be a lot of fun, I've been trying to get some more practice with Go lately so this got me wondering: "Is there an equivalent to OpenMP in Go?"

Although I did not find an exact drop-in replacement for OpenMP, posts on [Stackoverflow](https://stackoverflow.com/questions/36949211/is-there-a-simple-parallel-for-in-golang-like-openmp) lead me to realize I could accomplish similar goals using [Goroutines](https://golang.org/doc/effective_go.html#goroutines). Specifically, I was interested in creating a simple parallel for-loop to try and reimplement some of the labs in Go.

## parallel for example in c and go
Below is a simple parallel for-loop in C using OpenMP's [omp parallel for](https://www.ibm.com/support/knowledgecenter/SSGH2K_13.1.2/com.ibm.xlc1312.aix.doc/compiler_ref/prag_omp_parallel.html) directive. It is performing a portion of the [Helman-JáJá list-ranking algoritm](https://www.cc.gatech.edu/~bader/COURSES/UNM/ece638-Fall2004/papers/HJ99.pdf). The key thing to note here is that each element at `i` in the `rank`/`list` arrays in the examples below is being operated on independently. This allows each loop iteration to be safely executed in parallel.

```c
#pragma omp parallel for
for (int i = 0; i < n; i++) {
    long currIdx = next[i];

    if (currIdx != NIL) {
        rank[currIdx] += headPrefixData[sublists[currIdx]];
    }
}
```

Now let's see what this might look like in Go. Ignore the fact that the datastructures in play might be a bit different -- the intent behind the algorithm is the same.

```go
var wg sync.WaitGroup
wg.Add(n)
for i := 0; i < n; i++ {
    go func(i int) {
        defer wg.Done()
        (*list)[i].prefixData += sublists[(*list)[i].sublistHead].prefixData
    }(i)
}
wg.Wait()
```

Here we're doing the following:

1. Create a [WaitGroup](https://golang.org/pkg/sync/#WaitGroup) (`wg`) and telling it to expect to wait for `n` Goroutines to finish
1. Spawn a Goroutine for each iteration of the loop we want to parallelize
1. Tell each Goroutine to let the WaitGroup know it's done once it's performed the prefix add operation
1. Tell the WaitGroup to block until it has heard back from the `n` Goroutines

## a note on goroutine scheduling
You may be wondering why it's okay to create a potentially huge number (`n`) of Goroutines in the code above. The short answer is, Goroutines are multiplexed across the hardware threads and scheduled independently from the OS by Go's scheduler. [This blog post](https://rcoh.me/posts/why-you-can-have-a-million-go-routines-but-only-1000-java-threads/) does a pretty good job of explaining how Go can handle millions of Goroutines. This is a bit different from how [OpenMP handles scheduling](https://www.dartmouth.edu/~rc/classes/intro_openmp/schedule_loops.html) by divvying chunks of work among threads. At the end of the day, however, they're both means of distributing a large amount of work across a smaller, fixed number of available processors.

If you really want to go deep, [this talk](https://www.youtube.com/watch?v=YHRO5WQGh0k) from GopherCon 2018 by Kavya Joshi gives a great view into what is going on under the hood of the Goroutine scheduler.
