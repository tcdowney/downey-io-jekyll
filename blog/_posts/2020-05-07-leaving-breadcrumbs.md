---
layout: post
type: blog
title: "Leaving Breadcrumbs"
sub_title: "the joys of public note taking"
color: badge-accent-1
icon: fa-book
date: 2020-05-08
categories:
  - note taking
  - learning
  - internet memory
  - learning in public
excerpt: "This post is going to be a bit meta. I'm going to write a bit about why I take notes publically and, to a lesser extent, blog in general. I started posting to this blog six years ago for kind of a lame reason. I had purchased the `downey.io` domain name and had no clue what to do with it! My earliest content is reflective of that lack of intentionality. Nowadays, I primarily write for three reasons: to cement my own understanding of a subject, to create content where there is none, and to leave digital breadcrumbs for myself and others to find in the future."
description:
  "Why I publish my notes and take my learning journey online"
---

<div>
<img src="https://images.downey.io/blog/k8s-notebook-with-bangbangcon-west.jpg" alt="Tastefully arranged journal with Kubernetes stickers on blue cutting board">
</div>

This post is going to be a bit meta. I'm going to write a bit about why I [post my notes](https://downey.io/notes/) and, to a lesser extent, blog in general. I've been wanting to write on this for a while now, but just haven't gotten around to it. However, thanks to this Pandemic we're all in, I've found myself with no commute and a bit more free time. So here we are. 🙂

## Why I Blog

I started this blog six years ago for kind of a lame reason. I had purchased the `downey.io` domain name in 2013 and sat on it for a year. Soon it was time to renew, and I decided I had to do better in 2014. After all, `.io` domains didn't come cheap back then! So I made a few lackluster posts out of obligation and let the blog stagnate. I had a lot of trouble thinking of things to write about and felt that, as a new software engineer, I lacked the necessary expertise. In mid-2017, I suppose I began to feel more confident in my skills, and I started blogging again -- mostly about [Cloud Foundry](https://www.cloudfoundry.org/).

I still blogged pretty infrequently, though, since the effort and inspiration necessary to create a decent blog post remained high. However, in 2018 I had a revelation. I realized I could contribute by writing even shorter-form technical content and framing them as notes instead of fully-fledged blog posts! I started this section off with some riveting content on ["Creating a Cloud Foundry Read-only Admin User"](https://github.com/tcdowney/downey-io-jekyll/commit/833219c3c7ead77cba2ea85531bcc0a44f827a79#diff-5bf1040a046752e791c0a1e463bf30ea) and have continued from there. I've kept this up primarily for three reasons: to cement my own understanding of a subject, to create content where there is none, and to leave digital breadcrumbs for myself and others to find in the future.

I've found that I learn best by trying to explain a subject in my own words. While watching lectures or reading a book is fine at providing me with a high-level understanding of a topic, it all just feels a bit superficial until I jot it down somewhere. In school, I usually accomplished this the old fashioned way with pen and paper. Now it's 2020, though, and I'm a bit more advanced. I use a text editor. 🤯

But more importantly, I publish the notes on my site! This approach works for me for a couple reasons. To start, I've found that making them publically accessible motivates me to actually take notes as well as to do a thorough job. This way, I end up learning the material better _and_ I might make something that helps others out there... or even just my future self. I took this approach for some of my more difficult grad school coursework, and not only did my notes help me then, but now they're some of my most visited pages. These posts on [Kruskal's Minimum Spanning Tree algorithm](https://downey.io/notes/omscs/cs6515/graphs-minimum-spanning-trees-kruskal/) and the [Helman JáJá list ranking algorithm](https://downey.io/blog/helman-jaja-list-ranking-explained/) have been particularly popular for some reason. 🤔

Take my Kruskal's algorithm post, for example. There's tons of material out there on it, and mine was just a drop in a very big bucket. But the act of drawing out the algorithm step by step using my iPad<sup>1</sup> was invaluable in developing my own understanding of it. On the other hand, for the Helman JáJá list ranking algorithm, there was actually very little about it online apart from the original paper. And that paper was dense. I spent a lot of researching that one and referencing graduate theses that happened to mention it before I ended up grokking it. In this case, my goal was primarily to give back and provide a more accessible explanation of the algorithm for future HPC students.

There aren't really any tangible benefits to all of this, of course, but it sure brings me joy! I recently read a post by a developer named Shawn Wang that referred to this practice as "[Learning in Public](https://www.swyx.io/writing/learn-in-public/)," and he goes into deeper detail about why it's valuable. For me, though, it just turns the toil of notetaking into something that feels more fun.

## Internet Assisted Memory

In addition to it being a learning aid, I've found that making quick little note posts acts a form of digital breadcrumbs by leveraging the fact that Google and all those web crawlers out there are continuously indexing all of the available content on the internet. If you've ever stumbled upon a Github Issue or StackOverflow post that precisely matches the issue you're facing, you can thank the open web for that. Whenever I find myself searching for how to do something programming related and fail to find a satisfactory solution out there, I try to write up the eventual answer in a note post. Then, when I have the problem in the future and have long forgotten the answer, it will likely now be indexed by the search engines and much easier to find. I can't tell you how many times I've searched and rediscovered my own [how to curl using mTLS](https://downey.io/notes/dev/curl-using-mutual-tls/) notes.

Scientific American says that the internet is [ruining our ability to memorize things](https://www.scientificamerican.com/article/internet-transactive-memory/), but I say embrace it<sup>2</sup>. In tech, there's way too much to learn, and the landscape is changing way too fast to rely solely on memory. Instead, I like to make mental pointers to information and rely on my ability to rediscover as needed. Writing these types of notes helps ensure that that information will be out there when I need it. Lazy loading for the mind!

Even if you don't want to go through the hassle of running your own site, I highly encourage everyone to leave breadcrumbs like this. Write out comprehensive Github Issues. Ask detailed questions on StackOverflow. If you figure it out later, answer your own questions ([don't be a DenverCoder9](https://xkcd.com/979/))! Contribute to the massive knowledge base that is the world wide web!

Cheers 🤙

---

* _<sup>1</sup> I use the Notability app and a first-gen [Apple Pencil](https://amzn.to/2LgesSp) to do draw these diagrams. I find it works really well for me!_
* _<sup>2</sup> Become a cybernetic organism. Just like [Arnold](https://terminator.fandom.com/wiki/T-800)._
