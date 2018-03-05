---
layout: post
type: blog
title: "Hack Mini - Linux Workstation Build Log"
sub_title:  "Build Log and Case Mod of My Mini (Hackintosh Compatible) Linux Computer"
color: teal
icon: fa-terminal
date: 2018-03-04
categories:
  - hackintosh
  - linux workstation
  - case mod
  - mITX case
excerpt:
 "Recently I've found myself wanting a dedicated desktop machine just for coding. Although I do most of my development at work on iMacs and at home on an aging MacBook Air, I decided against buying another Mac -- the price and performance I wanted just wasn't there. \"Linux is close enough\", I thought, so I decided to build this small, discrete machine just for development."
description:
  "Parts list, build log, and case mod pictures of my mini-ITX Linux workstation."
---

<div>
<img src="https://images.downey.io/2018-03-04/hack-mini-linux-workstation-10.jpg" alt="Orange and off white mITX Linux Computer">
</div>

Recently I've found myself wanting a dedicated desktop machine just for coding. Although I do most of my development at work on iMacs and at home on an aging MacBook Air, I decided against buying another Mac -- the price and performance I wanted just wasn't there.

I already have a flashy, Windows running, RGB filled monstrosity of a gaming PC that looks kinda like a Sith holocron -- or maybe just a tower out of Tron. Regardless, it is a very distracting piece of machinery and I didn't want to fiddle about with dual booting. Instead I wanted something smaller and more discrete. A computer just for development. I decided to build a mITX computer with a bit of a retro theme. All of the parts I selected had decent compatibility with Ubuntu and could even be used in [building a Kaby Lake Hackintosh](https://www.tonymacx86.com/buyersguide/february/2018/) if you're so inclined.

Anyways, what follows is primarily just gonna be my parts list and some pictures I took of the case modding process, parts installation, and a few photos of the final machine.

## Parts List
<ul>
  <li><strong>Case</strong></li>
  <li><a href="http://amzn.to/2oJaMOi">Cooler Master Elite 110 mini-ITX Case</a></li>
  <li><strong>CPU</strong></li>
  <li><a href="http://amzn.to/2tf21jL">Intel Core i7 7700</a></li>
  <li><strong>CPU Cooler</strong></li>
  <li><a href="http://amzn.to/2thIQFR">Noctua NH-L9x65</a></li>
  <li><strong>Motherboard</strong></li>
  <li><a href="http://amzn.to/2CXMVyM">ASRock Z270M-ITX/AC LGA1151/ Intel Z270 Motherboard</a></li>
  <li><strong>RAM</strong></li>
  <li><a href="https://www.newegg.com/Product/Product.aspx?Item=N82E16820231878">G.SKILL Ripjaws V Series 16GB (2 x 8GB) 288-Pin liR4 SDRAM liR4 3000</a></li>
  <li><strong>Graphics Card</strong></li>
  <li><a href="https://www.evga.com/products/product.aspx?pn=04G-P4-6253-KR">EVGA Geforce 1050 Ti Single Fan</a></li>
  <li><strong>Boot Drive</strong></li>
  <li><a href="https://www.newegg.com/Product/Product.aspx?Item=N82E16820147373">Samsung 850 EVO 500GB 2.5-Inch SATA III Internal SSD</a></li>
  <li><strong>Storage Drive</strong></li>
  <li><a href="http://amzn.to/2Fgg8qD">Western Digital Blue 2TB 3.5-Inch Desktop HDD</a></li>
  <li><strong>Case Fan</strong></li>
  <li><a href="http://amzn.to/2H4k3HE">Noctua NF-F12 iPPC-2000 PWM 120mm Fan</a></li>
  <li><strong>Case Lighting</strong></li>
  <li><a href="http://amzn.to/2FcxOr3">Autai RGB LED Light Strip with Remote Control</a></li>
  <li><strong>Off White Spray Paint</strong></li>
  <li>Rustoleum Painters Touch UltraCover Satin Heirloom White</li>
  <li><strong>Orange Spray Paint</strong></li>
  <li>Rustoleum Painters Touch UltraCover Satin Rustic Orange</li>
  <li><strong>Primer</strong></li>
  <li>Rustoleum Flat White Primer</li>
  <li><strong>Clear Coat</strong></li>
  <li>Rustoleum Matte Clear Enamel</li>
</ul>

I originally purchased an Intel Core i7 7700k because I got a good deal one one, but I ended up returning it because I was unable to adequately cool it without liquid cooling within the confined space of the Elite 110 case. Since I wasn't planning on overclocking this machine it wasn't necessary anyway. I wanted to purchase 32 GB of RAM, but prices were already much higher than I expected due to cryptocurrency miners.

As I mentioned earlier, I was concerned with the thermals of this case so I decided to spend a bit more and go with a high quality Noctua case fan and one of the better low profile Noctua CPU coolers. As a benefit, the much maligned brown color of the Noctua fans actually complemented my case design. 😊

I selected the ASRock Motherboard due to positive reviews of folks on the TonyMac Hackintosh forums in case I ever wanted to go down that road.

This was last Fall when I purchased these parts. As of writing this post (March 2018) the RAM and graphics card I purchased are now even more exorbitant. 😭

## Case Mod

<div>
<img src="https://images.downey.io/2018-03-04/hack-mini-linux-workstation-1.jpg" alt="Cooler Master Elite 110 mITX Case Taken Apart">
</div>

I really liked the cubic design of the Cooler Master Elite 110 and its mesh grate. I wanted to make it a little more my own, however, so I decided to head to Home Depot and get some spray paint. I wanted to go for a more retro look since the case kind of looks like an old speaker, so I went with an off-white, almost cream "Heirloom White" for the case and "Rustic Orange" for the grill.

I took apart the case and sanded down the metal portion to make it easier for the primer to adhere.

<div>
<img src="https://images.downey.io/2018-03-04/hack-mini-linux-workstation-2.jpg" alt="Cooler Master Elite 110 mITX Case Taken Sanded">
</div>

<div>
<img src="https://images.downey.io/2018-03-04/hack-mini-linux-workstation-3.jpg" alt="Cooler Master Elite 110 mITX Case Painting">
</div>

I covered pieces of the case that shouldn't be painted (USB ports for example) with painters tape and applied the several coats of primer. After that I applied many many coats of the final paint, sanded down any imperfects, and applied more coats. At the end I applied a final coat of matte clear coat to protect it.

<div>
<img src="https://images.downey.io/2018-03-04/hack-mini-linux-workstation-4.jpg" alt="Cooler Master Elite 110 mITX Case Painting">
</div>

## Build Log

The build was pretty uneventful. I'm not going to go into too much detail, but I did take some pictures during the parts and process. I had hoped for some pictures of these parts integrated together as I was researching, so this part of the post is more intended for past me and people like him. 🙂

## Noctua NH-L9x65 CPU Cooler
<div>
<img src="https://images.downey.io/2018-03-04/hack-mini-linux-workstation-5.jpg" alt="Noctua NH-L9x65 CPU Cooler">
</div>

## Noctua NH-L9x65 on ASRock Z270M-ITX/AC with G.SKILL Ripjaws V Ram
<div>
<img src="https://images.downey.io/2018-03-04/hack-mini-linux-workstation-6.jpg" alt="Noctua NH-L9x65 on ASRock Z270M-ITX/AC with G.SKILL Ripjaws V Ram">
</div>

## ASRock Z270M-ITX/AC with EVGA Geforce 1050 Ti Single-fan Graphics
<div>
<img src="https://images.downey.io/2018-03-04/hack-mini-linux-workstation-7.jpg" alt="ASRock Z270M-ITX/AC with EVGA Geforce 1050 Ti SC Single-fan">
</div>

## Cooler Master Elite 110 with Noctua 120mm Fan and 3.5 inch HDD
<div>
<img src="https://images.downey.io/2018-03-04/hack-mini-linux-workstation-8.jpg" alt="Cooler Master Elite 110 with Noctua NF-F12 120mm Fan and 3.5 Inch Hard Drive">
</div>

## White and Orange Cooler Master Elite 110 Case Mod
<div>
<img src="https://images.downey.io/2018-03-04/hack-mini-linux-workstation-9.jpg" alt="White and Orange Cooler Master Elite 110 Case Mod">
</div>

## Remote LED Lighting in Hack Mini Linux Workstation
<div>
<img src="https://images.downey.io/2018-03-04/hack-mini-linux-workstation-11.jpg" alt="Remote LED Lighting in Hack Mini Linux Workstation">
</div>
