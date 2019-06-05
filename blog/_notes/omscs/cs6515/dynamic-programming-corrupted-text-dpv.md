---
layout: post
type: note
title: "Dynamic Programming - DPV 6.4"
sub_title: "an explanation for the sentence with corrupted text problem"
color: red
icon: fa-book
date: 2019-06-04
categories:
  - graduate algorithms
  - dpv
  - dynamic programming
  - dasgupta papadimitriou vazirani
description:
  "My solution for problem 6.4 in the Dasgupta Papadimitriou Vazirani (DPV) Algorithms textbook"
---

This was an ungraded practice problem for our [CS6515 class](https://gt-algorithms.com/). There are [existing solutions](http://www.cs.rpi.edu/~goldsd/docs/fall2013-csci2300/sample-final-exam-solutions.pdf) out there, but I found them a bit unintuitive so this is my attempt at explaining the problem.

## Problem Summary
You are given a string _s_ containing _n_ chracters _s_[1..._n_]. The string is corrupted such that all punctuation has been removed. For example, the string "you are a bold one." would appear as "youareaboldone". You are also given a dictionary method, _dict(w)_, that is able to determine whether or not a substring _w_ of _s_ is a valid word. In other words, _dict("bold")_ would return _true_, while _dict("aboldo")_ would return _false_. You are tasked with doing the following:

1. Give a dynamic programming algorithm that can tell whether or not a string _s_ contains a sentence of valid words. This algorithm should take at most _O(n<sup>2</sup>)_ time.
2. If the string is valid output the sequence of words.

_Refer to page 178 of [the textbook](https://amzn.to/2WoPTuB) for the full, formalized problem description._

## Solution
I'm going to go about solving this problem similarly to my [knapsack problem explanation](https://dev.to/downey/solving-the-knapsack-problem-with-dynamic-programming-4hce) and do the following.

1. State the subproblems
2. Define the recurrence
3. Describe the memoization table structure
4. Whip up some pseudocode
5. Perform some quick Big O analysis of the algorithm

### Subproblem
Dynamic programming is all about identifying smaller subproblems, solving them, and using them to build up to the final solution. For this problem we can build off of **smaller prefixes** of _s_ that are of length _i_ where **0 ≤ _i_ ≤ _n_**.

Let's define our subproblem as:

**V(_i_) = whether or not (_true_/_false_) the string _s_ contains only valid words that exist in the dictionary in the string _s<sub>1</sub>_..._s<sub>i</sub>_**

### Recurrence
The substring of length 0 (empty string) is considered a valid word so our base case starts with the sentence being valid.
* **Base Case:** **V(0) = true**

Since we need to check the status of substrings within **_s<sub>1</sub>_..._s<sub>i</sub>_** in our dictionary we will need to introduce another variable _j_ such that **0 ≤ _i_ ≤ _i_**. Our recurrence will look as follows:

* **Recurrence:** **V(_i_) = _any_( for(_j_ in _1_..._i_) { _dict(s[j...i])_ AND V(_j_ - 1) } )**

So what is this saying? Basically for all characters in _s_ from 1 to _i_ we will loop over the possible substrings using _j_. If the substring of _s_ from _j_ to _i_ is a valid word in the dictionary **and** we recorded the previous word was valid by checking the ending of the previous substring via V(_j_ - 1). 

### Memoization Table Structure
Given that our subproblem definition takes just a single parameter, _i_, we should be able to get away with a 1-dimensional memoization table of length to contain partial values for strings of length 0 to _n_.

### Pseudocode Implementation
I decided to implement this one in Python instead of just pseudocode. You should be able to [run the following on Repl.It](https://repl.it/@tcdowney/dpv-6-4) using their Python 3 interpreter.

**Part 1 - Is the Sentence Valid?**

```python
# Base case
t[0] = True

# Recurrence
for i in range(1, n):
  t[i] = False
  for j in range(1, i+1):
    # i and j correspond to our memoization array t
    # which contains an extra element to represent the
    # empty substring. We must adjust them to work with
    # the s character array.
    si = i - 1
    sj = j - 1

    substr = "".join(s[sj:si+1])

    if d[substr] and t[j-1]:
      t[i] = True
      next_word_idx[j-1] = i

print("The string s contains a valid sentence:")
print(t[n-1])
```

**Part 2 - Output the Words**

```python
# Extract the words back out
prev = 0
words = []
for i in next_word_idx:
  if i != 0:
    word = s[prev:i]
    words.append("".join(word))
    prev = i

print("")
print("The words in the sentence are:")
print(words)
```

### Runnable Code
You can see the code in action in the following Python repl:

<iframe height="400px" width="100%" src="https://repl.it/@tcdowney/dpv-6-4?lite=true" scrolling="no" frameborder="no" allowtransparency="true" allowfullscreen="true" sandbox="allow-forms allow-pointer-lock allow-popups allow-same-origin allow-scripts allow-modals"></iframe>

### Big O Analysis
As you can see in the Python pseudocode above, most of the work happens in Part 1. Here we have two nested loops, the outer for _i_ from 1 to _n_ and the inner for _j_ from 1 to _i_. Since _i_ is at most _n_, this part ends up being _O(n<sup>2</sup>)_. In Part 2 when we extract the words back out, this is a simple loop from 0 to _n_ which ends up being _O(n)_. Part 1 dominates and the **overall complexity is _O(n<sup>2</sup>)_**.
