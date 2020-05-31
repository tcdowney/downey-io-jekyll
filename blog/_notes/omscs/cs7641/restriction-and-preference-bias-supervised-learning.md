---
layout: post
type: note
title: "Preference and Restriction Biases for Supervised Learning Algorithms"
color: badge-accent-3
icon: fa-graduation-cap
date: 2018-10-06
categories:
  - machine learning
  - restriction bias
  - preference bias
  - supervised learning
description:
  "Notes on preference and restriction biases for various supervised learning algorithms, including decision trees, ann, knn, svm, boosting, etc."
---
Scattered thoughts about a few supervised learning algorithms and their restrictiona nd preference biases -- it's just to help me organize my thoughts for the CS7641 midterm.

## What is Restriction Bias
Restriction bias is the representational power of an algorithm, or, the set of hypotheses our algorithm will consider. So, in other words, restriction bias tells us what our model is able to represent.

## What is Preference Bias
Preference bias is simply what representation(s) a supervised learning algorithm prefers. For example, a decision tree algorithm might prefer shorter, less complex trees. In other words, it is our algorithm's belief about what makes a good hypothesis.

### Occam's Razor
All things being equal (or roughly equal), simpler representations are preferred over more-complex representations for all of these algorithms.

## Decision Trees

### Restriction Bias
The set of hypotheses that can be modeled by decision trees.

### Preference Bias
* Prefers shorter trees.
* Prefers trees with good splits near the top (splitting on features with the most information gain).

## Artificial Neural Networks (ANN)

### Restriction Bias
Neural networks don't restrict much at all. At their most basic, you can represent boolean functions with a single layer network of threshold perceptrons.

For continuous functions you can can add a hidden layer to the network to map the output from the first layer to match the continous function.

Even arbitrary functions can be modeled by adding a second hidden layer to jump around.

Since there is not much restriction going on here, neural networks are prone to overfitting. Use cross-validation to measure performance and pick the correct complexity (e.g. number and size of hidden layers).

### Preference Bias
*Note:* Considering Gradient Descent over the perceptron training rule for the notes below.

In general, we prefer low complexity in our neural networks. Smaller weights, fewer hidden layers, and smaller hidden layers.

This is accomplished by:
* Choosing small, random values for the initial input weights. Helps us avoid local minima and ensures that when the algorithm is run subsequent times that it doesn't fall into the same traps.
* Smaller values for weights help avoid the overfitting that large values are prone to (since larger values allow a wider range of weights that can be applied).

## Support Vector Machines (SVM)

### Restriction Bias
Depends on the kernel chosen. Look into Linear vs non-linear kernels like RBF.
There needs to be some way of calculating similarity between instances. See: [Mercer Condition](https://www.quora.com/Why-should-a-kernel-function-satisfy-Mercers-condition)

### Preference Bias
Seeks to maximize margin to avoid fitting too closely to the training data. See:
[Hyperplane Separation Theorem](https://en.wikipedia.org/wiki/Hyperplane_separation_theorem)

## k-Nearest Neighbors (KNN)

### Restriction Bias
Nonparametric regression -- should be able to model anything as long as you can find a way to compute distance (similarity) between neighbors.

### Preference Bias
* Locality - Near points are posited to be similar
* Equality - All features matter equally
* Smoothness - By averaging values of the k-Nearest Neighbors and choosing points that are near each other we are expecting the functions we're modeling to behave smoothly

The fact that all features matter equally in KNN means that the algorithm is highly affected by the "Curse of Dimensionality." As the number of features (dimensions) grows, the algorithm requires a much larger quantity of training data to generalize accurately. In reality not all features provide the same amount of information so we need more instances to discover that.

## Boosting

### Restriction Bias
Same as the underlying weak learners within the ensemble.

### Preference Bias
Same as the underlying weak learners within the ensemble.

