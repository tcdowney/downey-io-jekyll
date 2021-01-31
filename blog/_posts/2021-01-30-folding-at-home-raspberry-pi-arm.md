---
layout: post
type: blog
title: "Installing Folding at Home on a Raspberry Pi"
sub_title:  "folding proteins for fun and science"
color: badge-accent-2
icon: fa-flask
date: 2021-01-30
categories:
  - raspberry pi
  - folding@home
  - pi folding@home
  - protein folding raspberry pi
excerpt:
 "Back when I was a kid I used to run Folding@Home on our old family computer -- a silver Gateway tower with a 1.8 GHz Pentium 4. I'm not sure how I found out about it, but I remember being inordinately excited by the prospect of contributing CPU cycles to simulate protein folding and help discover cures for cancer and other diseases. Today, you can buy a quad core Raspberry Pi that is more powerful than that Gateway for $35. Let's have some fun and see how well it can fold proteins!"
description:
  "How to install and run Folding@Home on a 64 bit Raspberry Pi"
---

<div>
<img src="https://images.downey.io/raspi/raspi-origami.jpg" alt="Raspberry Pi 4B with PoE Hat and paper origami crane">
</div>

Back when I was a kid I used to run [Folding@Home](https://foldingathome.org/) on our old family computer -- a silver Gateway tower with a 1.8 GHz Pentium 4. I'm not sure how I found out about it, but I remember being inordinately excited by the prospect of contributing CPU cycles to simulate protein folding and help discover cures for cancer and other diseases. Yeah, I was a nerd. 🤓

Anyways, I kind of forgot about the project until this past year -- thanks to Covid-19. 😒 In addition to the typical work units, Folding@Home was now distributing work to help researchers better understand the SARS-CoV-2 virus ([you can read more on that here!](https://foldingathome.org/diseases/infectious-diseases/covid-19/)). So once again I did my civic duty and fired up my computers to contribute!

My desktop with its GTX 1070 graphics card chewed through simulations like crazy -- leagues faster than the old Gateway ever could. It got me wondering, though, "How would my Raspberry Pis fare?" I've got a ton of these suckers sitting dormant these days, both from my [Pi Kubernetes cluster]({% post_url 2018-08-04-how-to-build-raspberry-pi-kubernetes-cluster %}) and the [Raspberry Pi fan performance tests]({% post_url 2020-07-04-raspberry-pi-4-heatsinks-and-fans %}) that I conducted. Rather than collect dust I thought it would be fun to put them to work (even though it's probably not an efficient use of power). After all, they're probably just as powerful as that old Gateway PC.

Unfotunately, when I first looked, no folding client existed for ARM processors. After all, why would the Folding@Home developers waste time building the software for low power ARM devices when desktop x86 processors and GPUs can run circles around them? I decided to search anyway and [forum posts like these](https://foldingforum.org/viewtopic.php?t=35998) started to give me hope. And sure enough, now it is!

## Installing Folding at Home on Raspberry Pi
Here's what it takes to start folding on a Raspberry Pi.

### 64 bit Raspberry Pi
You'll need a Raspberry Pi with a 64 bit processor to be able to run Folding@Home. A 3B or 4 will do nicely. Folding uses around 500MB of RAM so you'll be good with either a 1GB or 2GB model. These days, I recommend the Raspberry Pi 4 in either its 2GB or 4GB configuration for the best bang for your buck.

### Install the OS
In addition to your 64 bit Pi, you'll need a 64 bit OS to run the `arm64` Folding@Home client. The typical Raspbian/Raspberry Pi OS is 32 bit (since until recently Raspberry Pis did not have more than 4 gigs of RAM), so you'll need to download it specially.

You can find the latest ones here:
* [Raspberry Pi OS Full arm64 Images](https://downloads.raspberrypi.org/raspios_arm64/images/)
* [Raspberry Pi OS Lite arm64 Images](https://downloads.raspberrypi.org/raspios_lite_arm64/images/)

I chose to go with the "lite" option since I run my Pis headless. Next install it as you normally would ([follow these steps if you need help!](https://www.raspberrypi.org/documentation/installation/installing-images/)).

I usually do a few more things after flashing the OS image to the SD card. Namely, I...

1. Create a file named `ssh` in the root directory of the card via `touch ssh`. This enables ssh on the card for the default `pi` user (password is `raspberry` remember to change this!).
2. Configure WiFi for the Pi by creating a `wpa_supplicant.conf` file in the root directory. This looks like:

```
country=US
update_config=1
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev

network={
  scan_ssid=1
  ssid="your-network-SSID-here"
  psk="your-network-password-here"
}
```

This way I can quickly log on to my router, see what IP it gave the Pi, and connect to it over ssh.

```bash
ssh pi@192.168.1.10
```

### Installing the Folding@Home Client

<div>
<img src="https://images.downey.io/raspi/raspi-folding-installation.png" alt="Screenshot of a terminal installing Folding@Home on a Raspberry Pi">
</div>

Open up a terminal or `ssh` on to the Pi and make a new directory in your home directory called `fah` where we'll download the client (you can name this directory whatever you want).

```bash
mkdir ~/fah && cd ~/fah
```

Now, download the arm64 Folding@Home Debian package. At the time of writing this, the latest version was `7.6.21`, but you can [find the most recent ones here](https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-arm64/).

```bash
wget https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-arm64/v7.6/fahclient_7.6.21_arm64.deb -O fahclient.deb
```

Now install it! This will pop up a fancy interface for you to input your username, team number, and passkey (if you've got one).

```bash
sudo dpkg -i --force-depends fahclient.deb
```

It will also ask if you want to run it as a service automatically on start up. If you choose this you'll be able to see an entry for `FAHClient.service` under your `systemd` services. You can always change your config later by editing `/etc/fahclient/config.xml`.

That's it! If you ever want to uninstall Folding@Home from your Pi, just run `sudo dpkg -P fahclient`.

## Folding Performance Comparison
These things get pretty hot under heavy load, so I decided to test out three different configurations to see what kind of cooling was necessary to fold at max power without thermal throttling. I recorded temperature and clock speed stats while folding using [the same script](https://github.com/tcdowney/knick-knacks/blob/7cc6c9e47fd918f5d68bb938dec952dd2a323b58/raspberry-pi/raspi-metrics.sh) that I used in my cooling experiment. I dropped a few Amazon referral links to the various cases I used, so if you buy anything through them I'll earn a few bucks and maybe recoup a bit of the electric costs these little guys incurred. 😛

The amount and difficulty of work distributed by Folding@Home is variable so I let the Pis run for two weeks to see what they could accomplish.

### Raspberry Pi 3B in Aluminum Flirc Enclosure
<div>
<img src="https://images.downey.io/raspi/raspi-3b-flirc.jpg" alt="Raspberry Pi 3B in Flirc aluminum case and a purple origami crane">
</div>

First I tried out an old Raspberry Pi 3B that I had lying around. It's in a passively cooled aluminum [Flirc Case](https://amzn.to/3e0zOiA) that does a pretty decent job of keeping the CPU cool under normal usage. Even at 100% CPU usage during folding the Pi only reached 67C. Not _that_ cool, but not hot enough to throttle either.

* **Specs:** Broadcom BCM2837 ARM Cortex-A53 Quad Core CPU at 1.2 GHZ
* **Results:** 9 work units (WUs) completed and 4,179 points (Credit) earned

### Raspberry Pi 4B in Aluminum Argon NEO Enclosure
<div>
<img src="https://images.downey.io/raspi/raspi-argon-neo.jpg" alt="Raspberry Pi 4 with Argon NEO Case">
</div>


Next I tried one of my Raspberry Pi 4Bs, this one in an aluminum [Argon NEO case](https://amzn.to/2BtOzO4) that's pretty similar to the Flirc case on the 3B. Raspberry Pi 4Bs run both faster and hotter than the 3Bs did so I was curious to see if passive cooling was enough. In [the cooling experiments]({% post_url 2020-07-04-raspberry-pi-4-heatsinks-and-fans %} I had done, under heavy synthetic load the 4B would have to throttle its CPU in this case. Fortunately, this was not the case for folding. It was able to keep running at a full 1.5 GHz, albeit at a toasty 72C.

* **Specs:** Broadcom BCM2711B0 ARM Cortex-A72 Quad Core CPU at 1.5 GHZ
* **Results:** 24 work units (WUs) completed and 19,648 points (Credit) earned

### Raspberry Pi 4B with Tower Cooler and 40mm Fan
<div>
<img src="https://images.downey.io/raspi/raspi-cooler-tower.jpg" alt="Raspberry Pi 4 with RGB Cooler Tower temperature test">
</div>

My last experiment used another Raspberry Pi 4B with a [ridiculous cooling tower](https://amzn.to/3iy4U4C) attached (complete with 40mm RGB fan). This one did great during the cooling experiments so I expected it to perform decently for folding as well. Sure enough, it did. It was able to run at a steady 1.5 GHz and keep at a balmy 42C. This one could probably be overclocked to 1.6 or 1.7 GHz in order to eke out a tad more performance, but given the variability of work units it would be difficult to compare. It was able to complete more work than the other 4B, but given that it wasn't being throttled I'll just chalk that up to luck.

* **Specs:** Broadcom BCM2711B0 ARM Cortex-A72 Quad Core CPU at 1.5 GHZ
* **Results:** 27 work units (WUs) completed and 22,642 points (Credit) earned

## Summary
So in concolusion a modern desktop CPU and a GPU could smoke these Pis... and that's ok. I had fun waking up these long dormant little computers and that was worth it to me. If you've got an unused Pi sitting around consider putting it to use for a little bit as well. Maybe it will help cure something! 😊
