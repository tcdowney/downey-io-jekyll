---
layout: post
type: blog
title: "Fractal Design Terra Jade Workstation"
sub_title:  "My latest waste of money 🌝"
color: badge-accent-4
icon: fa-desktop
date: 2024-02-10
categories:
  - mitx pc build log
  - desktop workstation
  - fractal design terra jade build log
  - ryzen 7900x mitx
excerpt:
 "I originally set out to make a headless Linux server build running Proxmox -- basically a homelab that I'd keep in the basement -- but as I built out my parts list I realized I was making more of a desktop workstation. And as I explored the case options of 2024 I quickly fell in love with the Fractal Design Terra case in jade. Once I went down the mITX form factor path, I knew this thing wouldn't be suitable as a homelab. But that's OK though, I'm really happy with it. 😁"
description:
  "A brief build log of my new Ryzen 7900X mITX workstation and my goals for it."
---

👋 I'm back.

It's been going on two years since I've last posted anything and a lot has happened. We moved from the Bay Area to Colorado and even had a kid! 🏔️👶 But now that things have settled down a little bit, I'd like to get back in the groove and start blogging again. So I dusted off the cobwebs of this (nearly a decade) old Jekyll site and got the dev env running again. It's kind of crufty by this point, but in the words of Han Solo, "she's got it where it counts, kid."

Anyways, what better way to kick this off than with a new PC build!

<div>
<img src="https://images.downey.io/blog/jade-workstation.jpg" alt="Fractal Design Terra Jade Workstation">
</div>

## The Plan

My goals for this build were the following (in no particular order):

1. I wanted something compact enough to keep on my standing desk
1. I wanted a lot of cores (this thing has 12!) and RAM to run Kubernetes
1. I wanted a decent enough GPU to experiment with local AI models
1. I wanted it to look nice

I originally set out to make a headless Linux server build running [Proxmox](https://www.proxmox.com/en/) -- basically a homelab that I'd keep in the basement -- but as I built out my parts list I realized I was making more of a desktop workstation. And as I explored the case options of 2024 I quickly fell in love with the [Fractal Design Terra](https://www.fractal-design.com/products/cases/terra/terra/terra-jade/) case in jade. Once I went down the mITX form factor path [again]({% link _posts/2018-03-04-hack-mini-linux-workstation-case-mod-log.md %}), I knew this thing wouldn't be suitable as an extensible homelab. But that's OK though, I'm really happy with it. 😁

So I ended up building a Windows 11 Pro workstation (thanks Woot for the cheap license!) that I will run Linux on either through WSL2 or as plain old VMs. I prefer developing on Macs so the plan is to continue use my Macbook and Mac Mini for that and SSH into this machine when I need more power. Additionally, I'm also thinking of using it to replace my aging 2016-era gaming PC for photo and video editing.

So I chose to go with an AM5 Ryzen 7900X CPU because it has 12 physical cores (24 vCPU) and I got a good deal on it. RAM these days is a lot cheaper than I remember it being three or four years ago, so I went with 64GB of DDR5 (2x32) and I tossed in a decent NVMe SSD for the boot drive. I chose an NVIDIA GeForce 3060 with 12GB of RAM because that seems to be the cheapest off-the-shelf option for playing around with AI models at home. We'll see.

## The Parts

> 📢 Heads up! I participate in the [Amazon Associates affiliate program](https://affiliate-program.amazon.com/home), which means if you buy any parts through my links on this post, I will earn a small commission at no extra cost to you. With any luck, this may help me offset some of the costs for this build.

Like I mentioned earlier, I fell in love with the Jade color of Fractal Design's Terra case and basically worked backward from there. These are the parts I ultimately ended up using.

<ul>
  <li><strong>Case</strong></li>
  <li><a href="https://amzn.to/48bBm5M">Fractal Design Terra Case in Jade</a></li>
  <li><strong>CPU</strong></li>
  <li><a href="https://amzn.to/48aRULa">AMD Ryzen 9 7900X</a></li>
  <li><strong>Motherboard</strong></li>
  <li><a href="https://amzn.to/48iIZXP">ASRock B650I Lightning WIFI AM5 Mini-ITX Motherboard</a></li>
  <li><strong>RAM</strong></li>
  <li><a href="https://amzn.to/49sTg4J">Crucial Pro 64GB DDR5 5600MHz Desktop Memory</a></li>
  <li><strong>Graphics Card</strong></li>
  <li><a href="https://amzn.to/3HSQIBt">ASUS Dual GeForce RTX 3060 White OC Edition 12GB GDDR6</a></li>
  <li><strong>Power Supply</strong></li>
  <li><a href="https://amzn.to/42zUVTT">Corsair SF750 750W SFX Platinum PSU</a></li>
  <li><strong>Boot Drive</strong></li>
  <li><a href="https://amzn.to/42zx72w">Samsung 980 PRO 2TB NVMe PCIEe 4 SSD</a></li>
  <li><strong>Secondary Drive</strong></li>
  <li><a href="https://amzn.to/3ODSB8Q">Western Digital WD_BLACK 1TB NVMe PCIEe 4 SSD</a></li>
  <li><strong>CPU Cooler</strong></li>
  <li><a href="https://amzn.to/487uhmE">Noctua NH-L12 Ghost S1 with 92mm PWM Fan</a></li>
  <li><strong>Case Fan</strong></li>
  <li><a href="https://amzn.to/3OGOIjn">Noctua NF-A12x15 120mm PWM Fan</a></li>
  <li><strong>Case Fan Accessories</strong></li>
  <li><a href="https://amzn.to/3usPJoq">120mm Fan Grill Guard</a></li>
</ul>

I primarily purchased them online from Amazon and Newegg, but picked up the processor and case at Microcenter since I'm fortunate enough to have one nearby and they tend to have the best prices on CPUs.

## The Build

This is the second mITX build I've done and definitely the trickiest build overall due to the tight confines of the case.

<div>
<img src="https://images.downey.io/blog/jade-workstation-cpu.jpg" alt="AMD Ryzen 7900X CPU for Terra Jade Workstation">
</div>

Fortunately Fractal Design's instructions were pretty straightforward and my parts list was fairly minimal. The case has room for a 2.5" SSD to be placed in the back, but even with my small form factor PSU that would have been very tight. That's why I went with the two m.2 drives and I plan on finally getting a NAS for media storage.

Just take a look at this cable management. Lovely!

<div>
<img src="https://images.downey.io/blog/jade-workstation-cable-management.jpg" alt="Fractal Design Terra Jade Cable Management">
</div>

Also as you can see, there was barely any room to spare for the CPU cooler! I had to install it upside down and adjust the case's internal spine slightly (went from position 4 to 2.5ish) so that I could close the side panel.

After shoving all of the power cables into the case they were brushing up against my single exhaust fan so I had to shield it with a 120mm grill guard.

My GPU was fairly compact so it fit with no problem, the case is long enough for most three-fan models I'd imagine.

<div>
<img src="https://images.downey.io/blog/jade-workstation-gpu.jpg" alt="Fractal Design Terra case with side panel open revealing the GPU">
</div>

In hindsight I probably should have tested out the components a bit outside of the case, but I was fortunate and everything worked on the first try.

## The Heat

When I picked up the 12-core [Ryzen 7900X](https://www.amd.com/en/products/cpu/amd-ryzen-9-7900x) CPU and case from Microcenter, the employee at the desk looked at me incredulously. "You're going to put that beast in that?" he said. I said "yep" and mentioned the cooler I was going to use and my (non-gaming) use cases. He still didn't really buy it, and maybe he was right. When I first booted up the machine and ran some lightweight bench marks I was hitting 80+ Celsius temperatures. That wasn't great.

So I installed AMD's [Ryzen Master](https://www.amd.com/en/technologies/ryzen-master) software which is typically used for overclocking and underclocked the thing by putting it into "eco mode." This runs the CPU at 65 watts instead of its typical 170W TDP and I started getting much better temperatures -- around 50-60C at idle. Obviously not the greatest, but better.

I probably should have just gone with an mATX build, but I went for aesthetics over practicality. Oh well. Time will tell whether or not this was all a mistake, but so far so good.

## The Dilemma

So why did I build this again? Partially because I haven't built on in five years and wanted an upgrade and partially because I just love how this case looks. As I mentioned earlier, I plan on running Kubernetes in [Kind](https://kind.sigs.k8s.io/) on it for some personal projects and I want to play around with some [Hugging Face](https://huggingface.co/docs/datasets/en/tutorial) AI/ML tutorials. I haven't done any ML since grad school so it should be fun to get my feet wet with that again.

And, since we've got the kid now, I plan on rekindling my interest in photography and maybe even editing some home videos on this thing. Anyways, I'm excited for what comes next!

Going forward, I hope to blog at least once a month and this machine will help with that.

Only question remaining is... what should I name it? I was originally thinking "kermit" cause it's green, but the jade color really doesn't give off kermit vibes. It reminds me a little bit of the planet Naboo from Star Wars and I'm a nerd so maybe I'll go with that. To be decided... 🐸