---
layout: post
type: blog
title: "Migrating from Jekyll to Hugo to Ghost to Jekyll"
sub_title:  "There and Back Again: A Static Site Generator Tale"
color: green
icon: fa-pencil-square-o
date: 2017-05-20
categories:
  - blogging
  - static site generators
  - jekyll
  - hugo
  - ghost
excerpt:
  "In a world where new static site generators and blogging platforms crop up everyday it can be tempting to scrap everything and start anew.  This is the story of me doing just that -- moving from Jekyll to Hugo to Ghost and winding right back up at Jekyll.  A rambling tale of what I discovered and why I didn't end up migrating in the end."
description:
  "Why I stuck with Jekyll instead of continuing to spin my wheels searching for the best static site generator."
---

<div>
<img src="https://s3.amazonaws.com/images.downey.io/blog/subaru-park-city-journey.jpg" alt="Excuse #1 for not making blog posts: cross-country move">
</div>

It's been nearly 18 months since I have last posted to this blog. Sure, 2016 was a busy year for us -- we moved from Kansas City to the SF Bay Area and I started working toward my Master's -- but the real reason I haven't been posting was because I felt the itch to "upgrade" this site away from [Jekyll](http://jekyllrb.com/) before adding any new content.  I decided to act on this itch and find a blogging platform that met the following criteria:

1. Easy to publish new content
2. Be relatively low maintenance and not require a large time investment
3. Be affordable (under ~$10 a month)

## Hugo and Pals

Last April I started working on [Cloud Foundry](https://www.cloudfoundry.org/).  At the time, a lot of the original Ruby components of the project were being reimplemented in Go so I thought that maybe I could try migrating this site to use [Hugo](https://gohugo.io/).  I remembered that I had to write some Ruby and know a bit about the various Ruby asset compilation options (I ended up using [jekyll-assets](https://github.com/jekyll/jekyll-assets)) to get this site to work the way I wanted it to.  I assumed that Hugo would be the same and that I'd learn a thing or two.

Well, it turns out that with Hugo you just install the Hugo executable and you're pretty much good to go.  This is great if you just want to generate a static site without having to fiddle around with setting up your environment (i.e. installing Ruby, using Bundler, etc.), but that wasn't my goal here.  My current site looked more or less the way I wanted it to and I wasn't blone away with any of the existing Jekyll themes so I would have had to adapt my SASS/JS asset pipeline to this new Go binary world.  I didn't do a whole lot of investigation into what that would have looked like, but it [wasn't supported out of the box by Hugo](https://discuss.gohugo.io/t/support-for-html-css-js-preprocessors/127/9) so I would have had to switch it over to using Grunt or Gulp or something.  Not a deal breaker by any means, but not something I wanted to necessarily dedicate a Saturday to.  And why Hugo's speed was definitely impressive, my site is no where near large enough for it to matter.  Maybe one day.

I also briefly checked out other projects like the JS-based [Hexo](https://hexo.io/) and the more flexible, but also Ruby-based [Middleman](https://middlemanapp.com/) project, but neither offered any truly compelling reasons for me to make time investment and switch.

## Ghost Hunting

This is when I took a step back and decided that switching from Jekyll to another static site generator like Hugo was too much of a lateral move.  Maybe what I wanted was a more traditional blogging platform -- a lightweight CMS that would reduce a lot of the friction around writing posts and uploading images to my photo blog. Although I have had success with Wordpress in the past, I no longer have time to keep it patched and I wanted to try something new.  I remembered reading a while back about a open source blog platform called [Ghost](https://ghost.org/).  Ghost has a minimal, intuitive UI and a slick Medium-esque default theme, [Casper](https://demo.ghost.io/), so I felt it was worth a try.

I was hoping to use their paid hosted service, but $19 a month for a blog that gets a trickle of traffic each month was more than I was willing to pay.  Especially when my current setup is only costing me around 50 cents a month (most of that going to Route 53).

Luckily, though, the core of Ghost is open source so you can host it yourself. I initially looked in to [ghost-for-cloudfoundry](https://github.com/dingotiles/ghost-for-cloudfoundry) since the Cloud Foundry platform abstracts away a lot of maintenance aspects of self-hosting an app and I could host an HA two-instance deployment of it on [Pivotal Web Services](http://run.pivotal.io/) for around five bucks a month.  However, I soon realized that I wasn't including the cost of a cloud SQL database which would have run me at least another $10 a month.

So I checked out DigitalOcean since they [also make it easy to host Ghost applications](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-ghost-application) and I would be able to colocate a db on the same VM that was hosting the app.  I managed to set it up quickly enough, but then it dawned on me that I was no longer meeting my second goal of the blog being low maintenance.  I would now have to keep these VMs running and keep the Ghost software up to date -- and with work, family, and graduate school I just didn't have time for that.

At this point I briefly started looking at hosted Wordpress and, *gasp*, even SquareSpace.  Eventually other things took priority and I just stopped thinking about the site altogether.  That is until I upgraded my camera and wanted to upload some new photos, of course.

## Back to Basics

So after wasting a couple weekends trying out these various options, I decided to take another look at what I already had.  My Jekyll site was working just fine.  It may not use the latest and greatest in static site generating technology, but it gets the job done.  My plan is to offload the Jekyll site generation and AWS deployment steps of my site to some sort of CI environment (playing with GitLab CI right now) and checking out some of the various static site "CMS" options.

I also realized that most of my pain centered around my image uploading workflow.  Although my [mitty](https://github.com/tcdowney/mitty) tool helps with generating different size of images and getting them on S3, the process of exporting them out of Lightroom and manually turning the S3 images into Jekyll style "blog posts" is still painful.  I realized, though, that just switching blogging platforms wasn't going to fix that. I'm still undecided with how I'm going to solve this -- I might just end up using a hosted portfolio service like SmugMug or even just 500px since it's just a hobby for me.

**tl;dr**

I used by search for the perfect blogging framework as an excuse for procrastination and Jekyll works just fine. 🌝

<div class="post-script">
  <p>p.s.</p>

  <p>
    If you're interest in learning more about how I use Jekyll, I've recently written a new post on how I <a href="{{ site.baseurl }}{% post_url 2017-09-17-how-to-deploy-static-site-cloud-foundry %}">deploy Jekyll sites to Cloud Foundry</a>!
  </p>
</div>
