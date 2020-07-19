---
layout: post
type: note
title: "How to Make Kubectl Exec Run Against Multiple Pods"
sub_title: "thank you, xargs"
color: badge-accent-1
icon: fa-code
date: 2020-07-19
categories:
  - kubernetes
  - kubectl
  - kubectl exec
  - kubernetes exec multiple pods
description:
  "How to make kubectl exec run a command against multiple Pods."
---

I was really surprised to discover the other day that `kubectl` [does not support](https://github.com/kubernetes/kubernetes/issues/8876) running the same command against multiple `Pods` out of the box.
I get why that wouldn't be supported for interactive terminals, but seems like non-interactive commands should be fine.

Oh well. We can still do what we want thanks to UNIX tools like [xargs](https://en.wikipedia.org/wiki/Xargs).

```console
kubectl get pods -o name | xargs -I{} kubectl exec {} -- <command goes here>
```

Just replace the `<command goes here>` bit with what you want to do.

## Example: Setting Log Level to Debug for All Istio IngressGateway Envoys
Here's a real world example of when and how you might want to do this. The other day I was troubleshooting our Istio installation on a dev cluster and needed to set the log level of all of our ingress Envoy proxies to `debug`. One way to do this is to configure it through a `POST` request to each Envoy's admin `/logging` endpoint (on Istio this is on port `15000` by default). 

We had five Envoys and I was feeling lazy, so I cooked up the following:

```console
kubectl -n istio-system get pods -l app=istio-ingressgateway -o name | xargs -I{} kubectl -n istio-system exec {} -- curl -s localhost:15000/logging?level=debug -X POST
```

I'm sure there are other UNIX incantations that could do the same, but this got the job done for me and I'm proud of it. 😊👍
