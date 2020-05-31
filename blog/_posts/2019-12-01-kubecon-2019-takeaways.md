---
layout: post
type: blog
title: "Reflections on Kubecon 2019"
sub_title: "good times in San Diego plus a bonus Istio meetup on a boat"
color: badge-accent-3
icon: fa-ship
date: 2019-12-01
categories:
  - kubernetes
  - k8s
  - kubecon
  - conferences
  - istio
excerpt: "A little over a week ago, I had the privilege of attending Kubecon in San Diego. It was an amazing experience, if not just a tad overwhelming in attendance and scale. It was a lot to take in -- and also a lot of fun! Now that I've had a bit of a break, I've had a chance to revisit my notes. In this post, I'll jot down a few of my takeaways from the conference."
description:
  "Takeaways from Kubecon 2019 San Diego"
---

<div>
<img src="https://images.downey.io/blog/kubecon-main-stage.jpg" alt="Kubecon 2019 main stage">
</div>

A little over a week ago, I had the privilege of attending Kubecon in San Diego (thanks Pivotal!). It was an amazing experience, if not just a tad overwhelming in attendance and scale. It was a lot to take in -- and also a lot of fun! Now that I've had a bit of a break, I've had a chance to revisit my notes. In this post, I'll jot down a few of my takeaways from the conference.

## Size and Scale

I've been to a few tech conferences in the past, such as various Cloud Foundry Summits over the years and Gophercon, but none have been nearly as large as Kubecon. I'm not sure about the exact number of attendees, but I heard figures from anywhere between 8,000 to 12,000 people thrown around. There was an amazing energy because of this, and it was awesome to see a lot of the famous online tech personalities (influencers? celebrities? thought leaders? 😛) in real life.

Fortunately, the San Diego Convention Center is designed to handle crowds much larger than this, so there was always enough seating at sessions if you showed up on time. Still, though, it was a lot of people. I'm no stranger to crowds (love Disney World and tolerate BART), but after three days, I was happy to be done. The incessant din of conversation and booth music gets to you to overtime, so I was beyond grateful for the provided quiet room.

For me, though, it was well worth it. I had a lot of fun getting to watch [TGI Kubernetes](https://github.com/vmware-tanzu/tgik) live covering [dapr.io](https://dapr.io/) and [Project Octant](https://octant.dev/). The peak of this for me was waiting in a long Disneyland-esque line at the VMware booth to get a copy of "Kubernetes: Up and Running" signed by Joe Beda! 😂

Everything was over the top. Before the conference even began, I attended an Istio service mesh meetup that took place on a boat in the San Diego bay. Then on Tuesday, there were endless corporate happy hours and socials.  The nearly rained out Wednesday night conference party in the Gaslamp District was pretty fun as well. It's mind-boggling to think about how much money was spent by Big Tech over the week.

<div>
<img src="https://images.downey.io/blog/istio-meetup-boat.jpg" alt="Boat on San Diego Bay where Istio meetup took place">
</div>

## Vendor Booths

Every major player in Cloud had a presence at the conference. Microsoft, VMware, Google, and Red Hat/IBM all had large booths located near the entrance of the main vendor area. It was fascinating watching folks swarm these booths on Day 1 (myself included) to exchange their personal information for conference swag. Some of it was pretty good, too. Rancher was giving away some nice insulated waterbottles, and Red Hat was handing out tons of baseball hats (they kinda looked like they belonged as part of a Pizza Hut employee uniform). That was fun. My favorite vendor trend, though, was the book signings and giveaways. Pivotal was giving away signed copies of ["Cloud Native Patterns"](https://amzn.to/2Y4W5pg), Red Hat had ["Kubernetes Patterns"](https://amzn.to/2Rd0pkT), and of course, the Joe Beda signed copies of ["Kubernetes: Up and Running"](https://amzn.to/35TyWZO) at the VMware booth that I mentioned earlier. There's no better swag than the swag of knowledge. 🧐

## Keynotes and Talks

For the most part, I enjoyed the presentations this year. Some of the sponsored keynotes were a bit infomercial-ly, but in general, they were good. In particular, I enjoyed the [_In Search of the Kubernetes 'Rails Moment'_](https://www.youtube.com/watch?v=ZqQTEdHVaCw) keynote from Brian Liles. It spoke to me, not only because I got my start coding professionally in Rails, but because of its message around the need for better abstractions around Kubernetes. I especially appreciated this line:

> I don't want to write YAML. I want my app to tell something to deploy it.

The gist of it was that your average app developer does not want to and should not need to write a slew of YAML to deploy their app. The platform should provide sane deployment defaults while providing devs with the tools and power to customize what they need to. This sentiment reminded me a lot of [Cloud Foundry](https://www.cloudfoundry.org/) and how it helps devs run 12 Factor apps today. It also solidified for me, personally, the value in our efforts to [bring Cloud Foundry to Kubernetes](https://content.pivotal.io/blog/pivotal-brings-the-magic-of-cf-push-to-kubernetes).

There also was a persistent theme around the importance of the Kubernetes community. Sayings like "community over company" were bandied about, and speakers doubled down on the importance of ensuring that the Kubernetes community remain kind and welcoming. I found it all to be pretty empowering and motivating.

In [_Building the Cloud Native Kernel: Kubernetes Release Engineering_](https://www.youtube.com/watch?v=fcQROXxHsvs), it was mentioned that although there are 100+ commercial distributions, Kubernetes is yet to have a "Debian" distro -- basically a completely community-maintained distribution. I found this interesting. On the one hand, Kubernetes doesn't lend itself nearly as well to the hobbyist developer as desktop (or server) Linux. It's more suited toward serving the needs of larger organizations and teams -- not the individual. It's also not cheap to spin up the required VMs for a cluster, and keeping a cluster maintained and up to date requires skill, time, and effort. On the other hand, though, it would be pretty cool if such a community-led k8s distribution existed.

There were lots of other great talks too, and many that I was unable to attend. Fortunately, they're all on YouTube now. Since I'm still pretty new to the Kubernetes landscape, I took a "breadth over depth" approach to talk selection. I chose talks that sounded interesting to me (or by speakers I recognized), and that covered a wide array of topics. I tend to like this approach because it is difficult to go very deep in a 40-60 minute session. By seeking breadth, I'm able to convert some of my [unknown unknowns into known unknowns](https://en.wikipedia.org/wiki/Johari_window) and add even more to my heap of things to learn.

My favorite talk was probably [_Polymorphic Reconcilers in Kubernetes - Advanced DuckTyping_](https://www.youtube.com/watch?v=kldVg63Utuw). The content was interesting, but what I liked the most about it was the guy in a duck suit, the Comic Sans on the slides, and all the references to [Untitled Goose Game](https://goose.game/). Fun talk and an even more fun game.

## Final Takeaways

It was a fun, informative, and tiring week. I'm very grateful for the opportunity to attend, grow closer with my teammates, and interact with the broader Kubernetes community. San Diego was nice, though surprisingly rainy,  and overall, Kubecon was a great experience. If any of this sounds interesting to you, I recommend checking out the [talks on YouTube](https://www.youtube.com/playlist?list=PLj6h78yzYM2NDs-iu8WU5fMxINxHXlien) and to consider attending in 2020!

<div>
<img src="https://images.downey.io/blog/k8s-notebook.jpg" alt="Orange notebook and associated Kubernetes books">
</div>
