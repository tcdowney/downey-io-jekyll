---
layout: post
type: blog
title: "Adventures in CS 7641: Machine Learning"
sub_title: "\"It's over. It's done!\""
color: vapor-wave-blue
icon: fa-graduation-cap
date: 2018-12-09
categories:
  - omscs
  - georgia tech cs 7641
  - machine learning
  - cs 7641 machine learning help
excerpt: "I just wrapped up Georgia Tech's CS 7641 Machine Learning course last evening and although it was a pretty arduous experience, I got through it. CS 7641 really demystified the field of machine learning for me and took me out of my comfort zone as far as computer science classes go. It was a time-consuming and challenging journey, but ultimately very worth it. In this post, I reflect back on the course and provide resources that I found helpful."
description:
  "I just wrapped up Georgia Tech's CS 7641 Machine Learning course last evening and although it was a pretty arduous experience, I got through it. CS 7641 really demystified the field of machine learning for me and took me out of my comfort zone as far as computer science classes go. It was a time-consuming and challenging journey, but ultimately very worth it. In this post, I reflect back on the course and provide resources that I found helpful."
---

<div>
<img src="https://images.downey.io/blog/monticello-ryzen-based-machine-learner-downey.jpg" alt="The AMD Ryzen based Linux server that ran most of my project code. Hostname: monticello">
</div>

Wow, it's been months since I've written anything here. Between taking on additional leadership responsibilities at work and enduring through Georgia Tech's graduate Machine Learning course, it has just been difficult to find the time -- and energy. 😩

Fortunately, I just wrapped up [CS 7641](https://www.omscs.gatech.edu/cs-7641-machine-learning) last evening and felt as though a huge weight had been lifted. I feel a bit like Frodo after he destroyed the One Ring and am happy to repeat his famous line "it's over. it's done!" Time to get back to writing and learning Rust! This class definitely took me out of my comfort zone as far as computer science classes go. My undergrad CS experience focused primarily on [programming languages](https://www.cs.indiana.edu/research/programming-languages.html), algorithms, and theory. And my OMSCS coursework, at least up until now, has been almost exclusively within the [Computing Systems](https://www.omscs.gatech.edu/specialization-computing-systems) track. I decided to take CS 7641 because I've had multiple people recommend it as a "must-take" and I figured getting my feet wet in Machine Learning couldn't hurt. It was a pretty tough and time-consuming journey, but I got through it and now would like to reflect back on the experience. So if you're like I was -- new to machine learning and unfamiliar with the theory/math behind it -- please read on.

## Course Summary
CS 7641 Machine Learning (which I will from now on abbreviate as ML) is a survey of topics that make up the foundations of machine learning as a subject. The first several months of the course cover Supervised Learning and Optimization and the second half covers Unsupervised Learning, Markov Decision Processes, Reinforcement Learning, and a bit of Game Theory. The textbook for the course was Tom Mitchell's [Machine Learning](https://amzn.to/2QHkgsv) which I found useful -- albeit a bit dry. As many students were quick to point out, Deep Learning was conspicuously absent from the topic list. However, neural networks were explored in depth in several of the projects and, at least for me, the foundations that we learned in this course are more valuable. For example, I now feel prepared to enroll in [Fast.ai's Deep Learning course](https://course.fast.ai/), whereas before I wouldn't have even dared.

The lectures are taught by Georgia Tech's Charles Isbell and Brown University's Michael Littman and their friendly banters makes them exceptionally entertaining and engaging. The videos can border on being too long at times, but overall these were some of the best lectures I've watched in the OMSCS program so far.

### Topics
I briefly mentioned the main topics we covered earlier, but let's go a bit deeper.

**Supervised Learning -**
For the Supervised Learning portion of the course we learned about various types of supervised learning algorithms including decision trees, k-nearest neighbors (KNN), artifical neural networks (ANN), support vector machines (SVM), boosting (adaboost), and more. The project for this section involved experimenting with each of these algorithms by tweaking their hyperparameters and comparing and contrasting their peformance against several datasets.

**Optimization -**
During the optimization section of the course we explored several randomized optimization algorithms such as randomized hill-climbing, simulated annealing, genetic algorithms, and Isbell's own [MIMIC](https://www.cc.gatech.edu/~isbell/papers/isbell-mimic-nips-1997.pdf) algorithm. Part of the project for this section involved swapping out regular old backpropogation in our neural network from the first project with these optimizers and analyzing the performance impact.

**Unsupervised Learning and Feature Transformation -**
After the midterm exam we learned about Unsupervised Learning through several clustering algorithms (single linkage clustering, k-means, and expectation maximization) and explored some techniques for dimensionality reduction such as Principal Component Analysis (PCA), Independent Component Analysis (ICA), Random Component Analysis (RCA), and Linear Discriminant Analysis (LDA). We applied these clustering and dimensionality reduction techniques to our datasets during a project and analyzed their effects.

**Markov Decision Processes and Reinforcement Learning -**
The final main topic we covered was Reinforcement Learning and modeling problems as Markov Decision Processes. The project for this portion had us choose two Markov Decision Processes (I chose stochastic variants of the [OpenAI Gym Frozen Lake problem](https://gym.openai.com/envs/FrozenLake8x8-v0/)) and apply policy-iteration, value-iteration, and a Q-learner to the problem. This portion of the course was conceptually very similar to the final half of [CS 7646 Machine Learning for Trading](https://www.omscs.gatech.edu/cs-7646-machine-learning-trading). CS 7641 went in to far greater detail, however, and with less hand holding.

### Projects

Speaking of projects, the four that we worked on throughout the course managed to consume the majority of my weekends (and some evenings) this past semester. The gist behind all of them was to select several datasets of your choosing (I used [Adult census data](https://archive.ics.uci.edu/ml/datasets/adult) and the [Spambase spam email dataset](https://archive.ics.uci.edu/ml/datasets/spambase)), "implement" the required machine learning algorithms, apply them to your data, and analyze the results. And when I say "implement", I mean find and use libraries like [scikit-learn](https://scikit-learn.org/stable/) that implement them for you. In fact, this may come as a surprise to many of you, your code implementations are worth absolutely nothing in this class. Project grades are purely based on the quality of your (12 page+) analyses and your understanding of the material.

In the past, I've been able to fall back on my coding ability when the courses get tough, but since the project code was worth exactly 0% this was not the case in ML. I ended up producing some pretty gnarly looking Python (and even Jython) code in this class because of this and it was honestly pretty liberating. I already know how to program and I didn't know much about neural networks, Kernel-SVM, k-means clustering, Q-learners, etc. This course structure encouraged me to spend most of my time ensuring that I truly understood the algorithms themselves -- at least well enough to come up with some insights while comparing their results.

We were given between three and four weeks to complete each project, which sounds like a lot of time, but it was really not -- especially with a midterm exam in between due dates. Depending on the size of your datasets, training some of these algorithms and performing cross-validation to tune your hyperparameters can take hours (or even days). If you just have a laptop, I'd highly recommend in investing in a multi-core (Ryzen 🙂) desktop machine or cloud VM instances (there are often [student credits available](https://aws.amazon.com/blogs/aws/aws-educate-credits-training-content-and-collaboration-for-students-educators/)). Getting the code working and running takes time, but as I mentioned earlier, it's not worth anything in isolation. You then have to make sense of your data and write a 10-12 page analysis on your results. Between all of the above and working full-time, completing these projects was more than a tad stressful. If I had only one recommendation to give for these projects it would be to start early since life _will_ get in the way. You don't want to be nervously watching the clock while your computer has been musing over the data for hours.

<div>
<img src="https://images.downey.io/blog/monticello-ryzen-server-running-clustering-code-downey.png" alt="Linux server with all 12 cores under heavy load running machine learning clustering">
</div>

## Helpful Resources
I did not have the math or analytics background that many of my fellow classmates had so I spent a decent amount of effort trying to backfill any knowledge gaps. Luckily there were lots of good resources online!

### Slack
The [OMSCS Study Slack](https://omscs-study.slack.com/) instance's `#cs7641` channel had a pretty low signal-to-noise ratio (lots of gifs and chatter), but it was home to many former students who were always happy to give advice (thanks Jontay 😊). It was also a good place to get encouragement from fellow students currently taking the class and bounce ideas off each other. Professor Isbell himself would frequently drop by as well!

### Stack Overflow
Searching for questions like "what is the difference between policy-iteration and value-iteration" often brought me straight to [Stack Overflow](https://stackoverflow.com/questions/37370015/what-is-the-difference-between-value-iteration-and-policy-iteration) where the answers were surprisingly helpful. Along these lines, Quora also provided some fruitful discussions.

### Youtube
Sometimes I needed topics explained differently or more in-depth than the course's own lectures. Luckily, lots of folks have posted videos on Youtube explaining things in their own ways. For example, I found [this video on backpropagation in neural networks](https://www.youtube.com/watch?v=Ilg3gGewQ5U) by 3brown1blue very helpful during the Supervised Learning portions.

### Code Library Documentation
You will likely jump around between multiple programming languages (Python, Jython, and Java for me) and libraries (scikit-learn, seaborn, ABAGAIL, OpenAI Gym, etc.) and it's always important to remember to search the docs for examples. Thankfully, the libraries I primarily used [scikit-learn](https://scikit-learn.org/stable/documentation.html) and [seaborn](https://seaborn.pydata.org/) (for plotting) were extremely well documented.

## Final Takeaways
CS 7641 really demystified the field of machine learning for me. What used to conjure up images of intelligent T-800 terminators now brings to mind applied statistics and matrices. I feel like I now have sufficient familiarity to speak intelligently about various ML algorithms/topics and the foundations to continue learning more on my own.

It was a difficult class and there were times early on that I wanted to drop, but I'm very glad that I stuck it out and finished. I now know what Isbell meant when he said we'd look back on this class and cry "happy" tears. 😂

Now onward to [High Performance Computing](https://cse6220.gatech.edu) next semester!
