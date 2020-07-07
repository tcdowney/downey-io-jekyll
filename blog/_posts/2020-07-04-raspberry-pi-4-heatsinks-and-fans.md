---
layout: post
type: blog
title: "The Great Raspberry Pi Cooling Bake-Off"
sub_title:  "Comparing Passive Heatsinks and Active Cooling for the Raspberry Pi 4"
color: badge-accent-4
icon: fa-flask
date: 2020-07-04
last_modified_at: 2020-07-06
categories:
  - raspberry pi 4B
  - raspberry pi heat sinks
  - thermal paste raspberry pi
  - raspberry pi fans
  - science
excerpt:
 "Why is my Raspberry Pi 4 running so hot? You may know you need something to cool it down, but what? In this post we compare the performance of various Raspberry Pi coolers. All the way from the humble heatsink to a massive cooling tower complete with RGB fans."
description:
  "Why is my Raspberry Pi 4 running so hot? You may know you need something to cool it down, but what? In this post we compare the performance of various Raspberry Pi coolers. All the way from the humble heatsink to a massive cooling tower complete with RGB fans."
---

<div>
<img src="https://images.downey.io/raspi/raspi-cooler-tower.jpg" alt="Raspberry Pi 4 with RGB Cooler Tower temperature test">
</div>

Two years ago, I found myself alone over the Fourth of July and a bit bored. So, of course, I did the reasonable thing and conducted a performance comparison of a few of the cooling options available for the Raspberry Pi 3B. This comparison resulted in my post ["Raspberry Pi Heat Sink Science"](https://downey.io/blog/raspberry-pi-3-heat-sink-comparison/).

2020 and its Pandemic has gifted me with even more isolation (_ahem social distancing_ 😷) this Fourth, so why not make the best of it and create Raspberry Pi Heat Sink Science Episode II: The 4th Awakens! This time with Raspberry Pi 4Bs! Raspberry Pi 4s have way more RAM ([up to 8GB](https://www.raspberrypi.org/blog/8gb-raspberry-pi-4-on-sale-now-at-75/)) and also run faster than their predecessor -- their quadcore ARM A72 can be overclocked to upward of 2GHz. Unfortunately, they also [need more power](https://www.raspberrypi.org/documentation/hardware/raspberrypi/power/README.md) and run much hotter.

I'm super excited about having more RAM, so I'm planning on modernizing my [Raspberry Pi Kubernetes Cluster](https://downey.io/blog/how-to-build-raspberry-pi-kubernetes-cluster/) for 2020, but want to dig into just how much hotter these things get since that might affect my build design. I also just wanted an excuse to buy a ridiculous cooling tower for a Raspberry Pi. 😅

## Configurations and Components
I will be testing a Raspberry Pi 4B 4GB under the following configurations. 

_Full disclosure: these are Amazon affiliate links, so if you buy anything from them I'll receive a small percentage as compensation. It might help me recoup some of the costs of these experiments._ 🙏

1. No Heatsink
2. [Heatsink](https://amzn.to/3gsbpEy) (with [Thermal Paste](https://amzn.to/3gsDlrW))
3. [Heatsink + 30mm Fan](https://amzn.to/2ZR9W43)
4. [Power over Ethernet (PoE) Adapter with 25mm Fan](https://amzn.to/3ioFkiy)
5. [Argon NEO Case](https://amzn.to/2BtOzO4)
6. [GeeekPi Cooler Tower Heatsink + 40mm RGB Fan](https://amzn.to/3iy4U4C)

Because having a stable power source matters when overclocking the Raspberry Pi 4, I chose to use an 18 Watt/3.5 Amp [power supply by Argon](https://amzn.to/3e0yH2o) that had pretty good reviews. For the Power over Ethernet experiment, I used a [tp-link 4-port PoE switch](https://amzn.to/3f26SIt).

## Methodology
I started testing with a stock Raspberry Pi 4 using the latest firmware. At 1.5 GHz it was incredibly stable, even with no heatsink. This was boring. So the first thing I did was [overclock my Pi to 2.0 GHz](https://magpi.raspberrypi.org/articles/how-to-overclock-raspberry-pi-4#:~:text=%20How%20to%20overclock%20Raspberry%20Pi%204%20,the%20default%20CPU%20speed.%20Open%20a...%20More%20). This was surprisingly easy and stable with a decent power supply.

### Benchmarking the Raspberry Pi 4
In my previous post, I used the [`stress` tool](https://linux.die.net/man/1/stress) to create synthetic load on the Raspberry Pi's CPU. This time I wanted to do something slightly more real and opted to use [`sysbench`](https://github.com/akopytov/sysbench) and its prime number verification test to create CPU load.

```console
sysbench --test=cpu --cpu-max-prime=50000 --num-threads=4 run
```
### Measuring Temperature and CPU Clock Frequency
While running this benchmark, I ran [this script](https://github.com/tcdowney/knick-knacks/blob/7cc6c9e47fd918f5d68bb938dec952dd2a323b58/raspberry-pi/raspi-metrics.sh) in the background to output a CSV containing the temperature and CPU frequency for every second of the experiment.  Feel free to check out the script itself, but the important bits are the `vcgencmd measure_temp` command for getting the Raspberry Pi's temperature and the `vcgencmd measure_clock arm` command for getting the **current** clock frequency of the Pi's ARM processor.

The `vcgencmd measure_clock arm` command was a new one for me. Last time I just used whatever was in the `scaling_cur_freq` file, but discovered that this is more like a "desired frequency." The `vcgencmd measure_clock arm` command was giving me the _actual_ frequency, which is useful for detecting thermal throttling<sup>1</sup>.

```console
pi@raspberrypi:~ $ vcgencmd measure_temp
temp=34.0'C

pi@raspberrypi:~ $ vcgencmd measure_clock arm
frequency(48)=2000478464
```

To chart the results I used Python and friends: [Pandas](https://pandas.pydata.org/), [Matplotlib](https://matplotlib.org/), and [Seaborn](https://seaborn.pydata.org/). If you're curious, you can check out my (pretty rough) plotting code [here](https://github.com/tcdowney/knick-knacks/blob/master/raspberry-pi/temp-plots/plot.py).

The benchmarks typically took around three minutes to complete (completion time is indicated by a vertical dashed line on the graphs), and measurements were collected for five minutes to see how quickly the Pi cooled back down. So without further ado, let's look at some results!

---

_<sup>1</sup> - The Raspberry Pi 4 will thermal throttle, or [slow down its CPU](https://www.raspberrypi.org/documentation/hardware/raspberrypi/frequency-management.md), when its temperature is between 80-85°C, so this clock frequency measurement can tell us just how much!_

## Experiment 1: No Heatsink

<div>
<img src="https://images.downey.io/raspi/raspi-no-heatsink.jpg" alt="Raspberry Pi 4 with no heatsink temperature test">
</div>

The first experiment I ran was with the Pi in its default configuration: no heatsink whatsoever. Just the processor's heat spreader. Unsurprisingly this configuration fared the worst.

<div>
<img class="image-frame" src="https://images.downey.io/raspi/raspi-4-temp-charts/sysbench-no-heatsink.png" alt="Raspberry Pi 4 with no heatsink temperature chart">
</div>

The `sysbench` CPU benchmark took around 216 seconds to complete -- almost 40 seconds longer than the other configurations -- and the Pi exhibited significant thermal throttling. Notice how the CPU frequency oscillates between 2.0 and 1.3 GHz.

Temperatures started out fairly high at around 50°C and quickly reached the throttle zone. Without any cooling the Pi never reached its base temperature during the five minute measurement window.

**Noise levels:** Silent! It's not cooled at all!

## Experiment 2: Heatsink (with Thermal Paste)

<div>
<img src="https://images.downey.io/raspi/raspi-heatsink.jpg" alt="Raspberry Pi 4 with aluminum heatsink temperature test">
</div>

For the second experiment I used a cheap aluminum heatsink and some inexpensive Cooler Master thermal compound to affix it to the CPU.

<div>
<img class="image-frame" src="https://images.downey.io/raspi/raspi-4-temp-charts/sysbench-with-heatsink.png" alt="Raspberry Pi 4 with aluminum heatsink temperature chart">
</div>

The benchmark took around 181 seconds to complete -- significantly faster than the previous experiment.

Temperatures started out much lower at around 40°C. They still reached the thermal throttle zone, but it took much longer to get there. The throttling didn't begin until 150 seconds into the experiment, whereas with no heatsink throttling started just 60 seconds in. This is a significant improvement and shows that if your Pi is typically used with short, bursty workloads you can likely get by with just a simple heatsink. If your Pi is running sustained CPU-intensive workloads, however, the heatsink alone won't suffice.

**🙉 Noise Levels:** Silent! It's passively cooled.

## Experiment 3: Heatsink + 30mm Fan

<div>
<img src="https://images.downey.io/raspi/raspi-heatsink-30mm-fan.jpg" alt="Raspberry Pi 4 with aluminum heatsink and 30mm fan temperature test">
</div>

For the third experiment I kept the same heatsink on and added a cheap 30mm Raspberry Pi fan that I ordered. Unfortunately, the fan came with no mounting hardware so I had to improvise with some rubber bands. It's not pretty, but it got the job done.

<div>
<img class="image-frame" src="https://images.downey.io/raspi/raspi-4-temp-charts/sysbench-with-heatsink-fan.png" alt="Raspberry Pi 4 with aluminum heatsink and 30mm fan temperature chart">
</div>

The benchmark took a little over 178.6 seconds to complete. A few seconds faster than with the heatsink alone and basically the same result as the following tests.

Temperatures were much improved with just this simple fan. We started at 37°C and reached 64°C at our highest point. There was no thermal throttling and the Pi was able to rapidly cool itself back down. If I actually had a case to mount this fan on, I could probably stop here. But I don't, and we've got more experiments to run!

**🙉 Noise Levels:** Medium. The 30mm fan was pretty quiet. There was a slight hum, but nothing too bad.

## Experiment 4: Power over Ethernet Adapter + 25mm Fan

<div>
<img src="https://images.downey.io/raspi/raspi-poe-adapter.jpg" alt="Raspberry Pi 4 with PoE Hat temperature test">
</div>

The fourth experiment was probably the most practical one for me. As I mentioned earlier, for my next Kubernetes cluster I'm planning on powering the Pis with Power over Ethernet (PoE) so that I don't have to mess around with a handful of expensive power supplies. The PoE adapter (aka PoE Hat) comes with a built in 25mm fan. Since my cluster will have multiple Pis in close proximity it's important that this adapter can keep it cool.

<div>
<img class="image-frame" src="https://images.downey.io/raspi/raspi-4-temp-charts/sysbench-with-poe-adapter.png" alt="Raspberry Pi 4 with PoE Hat temperature chart">
</div>

Like before, the benchmark took a little over 178.6 seconds to complete. It was a few milliseconds faster than the 30mm fan, but since I only ran the benchmark once this isn't enough data to claim it was absolutely faster.

Temperatures were great -- we maxed out at around 62°C with no thermal throttling. I'm pretty confident now that this will do fine in a clustered-configuration.

**🙉 Noise Levels:** Medium-Loud. The 25mm fan was fairly loud and pretty whiny. In a cluster I could see this definitely getting annoying. So if you're using Raspberry Pis because they're quiet... you might want to reconsider if you plan on using the PoE adapter. I mean, it's not that bad, but if you are running it in a small dorm or apartment I could see it being a nuisance.

## Experiment 5: Argon NEO Case

<div>
<img src="https://images.downey.io/raspi/raspi-argon-neo.jpg" alt="Raspberry Pi 4 with Argon NEO Case temperature test">
</div>

For the fifth experiment I tested a case that I purchased for its aesthetics. The Argon NEO case is made of aluminum and pretty slim. For $15 it feels really high quality and makes the Pi look like a "real" computer!

<div>
<img class="image-frame" src="https://images.downey.io/raspi/raspi-4-temp-charts/sysbench-with-argon-neo.png" alt="Raspberry Pi 4 with Argon NEO Case temperature chart">
</div>

Internally the Argon NEO is affixed to the Pi's CPU with a piece of included thermal tape. This connects it to an aluminum column that lets it radiate heat throughout the entire case. Effectively making it into a massive heatsink! The results speak for themselves. We start at 34°C and make a very gradual climb as the benchmark runs. It tops out at 58°C -- our best performance yet!

I thought for sure that the small size of the case would inhibit air flow and cause it to get pretty hot, but I was pleasantly surprised with how well it performed<sup>2</sup>. For my Raspberry Pi 3 I've been using a [Flirc Case](https://amzn.to/3e0zOiA) that I've been pretty happy with. This one, however, definitely gives it a run for its money.

**🙉 Noise Levels:** Silent! It's passively cooled.

_<sup>2</sup> - I ran a longer experiment later and the Argon NEO was **not** able to keep a Pi cool when under load for hours at time. See the update at the bottom of the post for more details._

## Experiment 6: Cooling Tower + 40mm RGB Fan

<div>
<img src="https://images.downey.io/raspi/raspi-cooler-tower.jpg" alt="Raspberry Pi 4 with RGB Cooler Tower temperature test">
</div>

For the sixth and final experiment I got to test out my fun new toy: a cooler tower with a 40mm RGB fan that Amazon had recommended to me (they know me too well). It was a little irritating to assemble and mount, but overall not too bad.

<div>
<img class="image-frame" src="https://images.downey.io/raspi/raspi-4-temp-charts/sysbench-with-rgb-cooler-tower.png" alt="Raspberry Pi 4 with RGB Cooler Tower temperature chart">
</div>

As you can clearly see, this configuration performed the best. We started out at ~32°C and reached a peak of 50°C. The large heatsink tower with its (supposedly) copper heat pipes did an excellent job at drawing heat away from the CPU and the large, flashy RGB fan was able to blow all that heat away. Not only that, but it was able to cool the Pi back down extremely quickly once the benchmark had finished.

The only downsides are that it's bulky (about triples the height of the Pi) and cost the most at $22.

**🙉 Noise Levels:** Quiet. The quietest of the three fan configurations. The fan can also be powered off of the 3.3v port for even quieter operation (at the cost of higher temperatures). Pretty good!

## Summary
If all you care about is absolute cooling performance, go with the [cooler tower](https://amzn.to/3iy4U4C). It looks a bit ridiculous, it's expensive, and it's bulky, but it can sure keep a Pi cool.

However, if you can spare a few degrees and would prefer a more protective and practical case, I strongly recommend the [Argon NEO](https://amzn.to/2BtOzO4). This case is good if you have short (under 10 minute) bursty load, but not if you expect to run the Pi under sustained CPU load. Otherwise seek something with active cooling.

If you want to get by on a budget, just buy an aluminum heatsink. They only cost a few cents each when purchased in bulk. If you think you're likely to have sustained CPU intensive workloads, spend a few dollars more and get a [case with a small fan](https://amzn.to/2ZGJxpe).

If you're interested in the [PoE adapter](https://amzn.to/3ioFkiy) because you want it for its Power over Ethernet capabilities, know that it will do a fine job at cooling your Pi. However, definitely don't buy it just for the fan! I'm satisfied enough, though, that the PoE adapters will be good enough for my future cluster.

---

### Important Update

**_2020-07-06_**

I was impressed with the Argon NEO so chose to use it to run some long-running CPU-intensive tasks. I checked in on it later and just about burned myself on it! 🔥🚒

It was so hot I decided to put it on a silicone coaster to protect the furniture and run some longer tests. Here are the results of it versus the Cooler Tower when run for the better part of a day.

<div>
<img class="image-frame" src="https://images.downey.io/raspi/raspi-4-temp-charts/long-term-argon-neo.png" alt="Raspberry Pi 4 with Argon NEO long 8000 second experiment temperature chart">
</div>

After around 10 minutes of continuous CPU load the Raspberry Pi in the Argon NEO case eventually reached 80°C and reached a max temperature of 86°C. During this time it experience significant thermal throttling and was unable to cool itself back below 80. Once the CPU load was removed it took the case a while to passively cool the Pi back down to reasonable levels.

<div>
<img class="image-frame" src="https://images.downey.io/raspi/raspi-4-temp-charts/long-term-cooler-tower.png" alt="Raspberry Pi 4 with Cooler Tower long 8000 second experiment temperature chart">
</div>

The Cooling Tower + 40mm fan, on the other hand, only reached a max of 32°C and was able to rapidly cool itself back to the baseline once the experiment stopped.
