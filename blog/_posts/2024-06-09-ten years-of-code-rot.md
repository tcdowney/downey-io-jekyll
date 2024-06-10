---
layout: post
type: blog
title: "Code Rot"
sub_title:  "Celebrating a decade of downey.io"
color: badge-accent-5
icon: fa-birthday-cake
date: 2024-06-09
categories:
  - dependabot
  - github actions
  - software rot
  - bit rot
  - old jekyll site
  - ten years
excerpt:
 "As I was writing my last post a couple of months ago, the age of this site's decade old toolchain became evident. Maybe it was my new Apple Silicon Mac, or perhaps it was the fact that I hadn't updated any of the gems in over a decade. Whatever the reason, nothing worked! My site had finally succumbed to the dreaded code rot. I was left with a choice: either modernize the site a bit or start over from scratch. I chose to modernize."
description:
  "Celebrating ten years of Downey.io by containerizing and automating the build to combat software decay."
---

Last month, this site turned [ten years old](https://github.com/tcdowney/downey-io-jekyll/commit/1107f840eeff864b1c5c1b27f5648cb31ca89f0f). At the time, I was a fresh new software engineer who had just started my first real job. I was working with Ruby on Rails, so naturally, I created this site using the Ruby-based Jekyll static site generator. Since I was all about Rails, I incorporated `jekyll-assets` to layer on the Sprockets asset pipeline and fed it a smorgasbord of Thoughtbot SASS gems for styling. I even sprinkled in some jQuery for good measure. To cap it all off (and since I knew nothing about IaaSes at the time), I used a random gem called `s3_website` to publish it all to an S3 bucket. That all worked beautifully... for a little while.

As I was writing my last post a couple of months ago, the age of this site's toolchain became evident. Maybe it was my new Apple Silicon Mac, or perhaps it was the fact that I hadn't updated any of the gems in over a decade. Maybe it was both. Whatever the reason, nothing worked! My site had finally succumbed to the dreaded code rot. What is code rot, you might ask? Well, my good friend ChatGPT defines it as:

> Software rot, also known as code decay or software erosion, refers to the gradual deterioration of software performance or functionality over time, often due to an evolving operating environment or neglected updates and maintenance.

Yeah, that sounds about right. So I was left with a choice: either modernize the site a bit or start over from scratch (and embrace [link rot](https://en.wikipedia.org/wiki/Link_rot) instead). I chose to modernize.

Rather than attempt to boil the ocean and do it all at once, I decided to proceed tactically and in small increments. Since this is a static website, I'm not overly concerned with the fact that my toolchain is outdated (and CVE-ridden). Instead, I just wanted to make the publishing experience not completely atrocious. I think I succeeded.

I initially attempted to upgrade all of the site's dependencies but quickly hit a wall due to the fact that I was using outdated technologies like Sprockets (via `jekyll-assets`) and that delivering SASS frameworks via gems (Thoughtbot's Bourbon and Neat gems) is no longer in vogue. As I mentioned earlier, I didn't want to completely rewrite this site from scratch, so I decided to take a step back.

Instead of upgrading everything and getting this to run perfectly locally, I decided to [Dockerize](https://github.com/tcdowney/downey-io-jekyll/blob/main/Dockerfile) my build environment. Now, instead of needing to install a bunch of insecure, old, and incompatible gems directly onto my laptop, I could keep all of that contained within a container image. Out of sight, out of mind!

Thanks to that Dockerfile, I was able to build and run the site locally again (using AMD64 Docker emulation) and even publish it. Still, the experience was pretty rough. Despite having ample free time as a new father, I knew that if I wanted to actually write and publish content with any semblance of frequency, I would need to make this better.

This is where GitHub Actions come in. After a lot of trial and error (GitHub Actions did not like my `rbenv` setup), I finally got it working so that pushes to `main` are automatically published and uploaded to S3. This means that instead of requiring a computer with Docker and a dev environment installed, I can write and publish from anywhere, even from the [GitHub.dev web editor](https://docs.github.com/en/codespaces/the-githubdev-web-based-editor) as I'm doing right now! This change elevates the writing and publishing experience to almost that of a real blogging platform. I'm really quite happy with it and not sure why I waited ten years to do this.

So in short, I can now more reasonably write and publish to this site, and hopefully, that will encourage me to write a bit more! Here's to the next ten years of Downey.IO! 🥳