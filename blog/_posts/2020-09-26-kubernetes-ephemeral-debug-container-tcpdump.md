---
layout: post
type: blog
title: "Capturing Network Traffic from a Kubernetes Pod with Ephemeral Debug Containers"
sub_title:  "how to tcpdump a running pod"
color: badge-accent-1
icon: fa-plug
date: 2020-09-26
categories:
  - kubernetes
  - ephemeral debug containers
  - tcpdump kubernetes pod
  - wireshark kubernetes pod
excerpt:
 "he other day I had a situation where I needed to debug network traffic between an app and its Envoy sidecar. The app was using a minimal distroless container image and didn't have easy access to tcpdump. Fortunately, newer versions of Kubernetes have alpha support for ephemeral debug containers which allow us to spin up temporary containers (with debug tools) inside a running pod! In this post we'll see how we can use ephemeral containers and tcpdump to capture network traffic from a running pod."
description:
  "Using ephemeral containers to run tcpdump against a running Kubernetes Pod."
---

<div>
<img src="https://images.downey.io/kubernetes/kubernetes-tcpdump-wireshark-example.png" alt="tcpdump of a kubernetes pod displayed in wireshark">
</div>

The other day I had a situation where I needed to debug network traffic between an app and its Envoy sidecar. Fortunately, since the app image was Ubuntu-based and it was an unimportant dev cluster, I was able to just `kubectl exec` into a shell on the container and install `tcpdump` to capture packets.

With `tcpdump` installed, I could run it and pipe the output to my local [Wireshark](https://www.wireshark.org/).

```console
kubectl exec my-app-pod -c nginx -- tcpdump -i eth0 -w - | wireshark -k -i -
```

It was pretty slick, if I do say so myself, and made me feel like a [Hacker](https://en.wikipedia.org/wiki/Hackers_(film)). 😎

But what if this app had been using a [`distroless`](https://github.com/GoogleContainerTools/distroless) base image or was built with a [buildpack](https://buildpacks.io/)? I wouldn't have been able to install `tcpdump` on the fly, that's for sure. Maybe I could have installed it when building the image initially, but that adds a lot of friction and would require me to redeploy the Pods. Not ideal -- especially if the bug is hard to reproduce.

Fortunately for us, newer versions of Kubernetes come with some alpha features for [debugging running pods](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#ephemeral-container).

## Ephemeral Debug Containers
Kubernetes 1.16 has a new [Ephemeral Containers](https://kubernetes.io/docs/concepts/workloads/pods/ephemeral-containers/) feature that is perfect for our use case. With Ephemeral Containers, we can ask for a new temporary container with the image of our choosing to run inside an existing Pod. This means we can keep the main images for our applications lightweight and minimal and then slap on a heavyweight image with all of our favorite debug tools as necessary.

For example, let's say we have an app using a `distroless` image, and we really want to open up a shell and poke around. We could use Ephemeral Containers for that!

```console
kubectl alpha debug -it <my-app-pod> --image=busybox --target=<container-name-in-my-app-pod>
```

For our use case, maybe we can use an image that's optimized for network troubleshooting: [`nicolaka/netshoot`](https://github.com/nicolaka/netshoot).

We can use `kubectl alpha debug` with this image to capture packets with `tcpdump` and pipe them to our local Wireshark just as we'd done before!

Here's a concrete example of me using `tcpdump` to capture packets on the `eth0` interface<sup>1</sup> with my [`mando` app](https://github.com/tcdowney/mando):

```console
kubectl alpha debug -i mando-655449598d-fqrvb --image=nicolaka/netshoot --target=mando -- tcpdump -i eth0 -w - | wireshark -k -i -
```

_<sup>1</sup> - If you're using a service mesh you may also want to look at other interfaces like `lo` to inspect traffic between the sidecar proxy and your app container._

## Caveats

As of Kubernetes 1.19, Ephemeral Containers are still an alpha feature and are not recommended for production clusters. So chances are you won't have access to them yet in your environment. As an alpha feature, the interface and functionality of the feature is liable to change, so don't get too attached to the current implementation! It's such a useful feature, however, I'd doubt they'd cut it entirely.

There are still ways to get early access today, though.

If you're using a managed Kubernetes service like GKE you can create an (unsupported) [alpha cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-an-alpha-cluster) that will have all sorts of experimental features enabled. I'm less familiar with other managed offerings, but chances are they'll have some form of alpha release channel was well.

Or if you're running a local `kind` cluster, BenTheElder shows how you can enable ephemeral containers [here](https://github.com/kubernetes-sigs/kind/issues/1210#issuecomment-570399316) with the following `kind` config:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
featureGates:
  EphemeralContainers: true
```

If you're using a custom `kubeadm` deployed cluster, you can [configure the Kubernetes control plane components](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/control-plane-flags/) to run with the `--feature-gates=EphemeralContainers=true` flag.

## Alternatives
If for some reason you can't enable ephemeral containers and you really want to capture some packets, don't despair! 😌

Check out [`ksniff`](https://github.com/eldadru/ksniff) as an alternative. It can create a privileged Pod that will create a new container that shares the same network namespace as your target Pod and let you capture packets that way.

If you can't run privileged pods and can't add tcpdump to the container image yourself, well...

I'm sure you'll figure something out.

Best of luck! 🙂
