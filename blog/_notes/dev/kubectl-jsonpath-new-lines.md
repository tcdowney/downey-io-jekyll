---
layout: post
type: note
title: "How to Make Kubectl Jsonpath Output On Separate Lines"
sub_title: "adding new lines to '-o jsonpath' so that it actually does what you want"
color: badge-accent-5
icon: fa-code
date: 2020-07-19
categories:
  - kubernetes
  - kubectl
  - jsonpath new lines
description:
  "How to make kubectl output jsonpath results on separate lines."
---

Getting `kubectl` to output [jsonpath](https://kubernetes.io/docs/reference/kubectl/jsonpath/) results on separate lines is something that I have to Google every time. 😖

For example, the following command extracts the `podIP` for every running `Pod` across all namespaces.

```console
kubectl get pods -A -o jsonpath='{.items[*].status.podIP}'
```

It returns something like the following:
```console
10.244.0.11 10.244.0.8 10.244.0.14 10.244.0.10 10.244.0.6 10.244.0.12 10.244.0.13 10.244.0.15 10.244.0.7 10.244.0.9 10.244.0.3 10.244.0.2 10.244.0.5 172.18.0.2 172.18.0.2 172.18.0.2 172.18.0.2 172.18.0.2 172.18.0.2 10.244.0.4
```

That's not the friendliest output to work with, that's for sure. 🙅‍♀️

## Adding New Lines
You can use the jsonpath `range` function to iterate over the list and tack on a new line after each element with `{\n}`.

```console
kubectl get pods -A -o jsonpath='{range .items[*]}{.status.podIP}{"\n"}{end}'
```

This outputs:
```console
10.244.0.11
10.244.0.8
10.244.0.14
10.244.0.10
10.244.0.6
10.244.0.12
10.244.0.13
10.244.0.15
10.244.0.7
10.244.0.9
10.244.0.3
10.244.0.2
10.244.0.5
172.18.0.2
172.18.0.2
172.18.0.2
172.18.0.2
172.18.0.2
172.18.0.2
10.244.0.4
```

Awesome! Now we can work with the output using all sorts of standard UNIX utilities that operate on new line (e.g. `sort`, `awk`, `uniq`, etc.).

## Bonus

You can use other whitespace characters too. So imagine we wanted to print the `Pod` namespaces/names along with their IPs and separate them by a comma.

```console
$ kubectl get pods -A -o jsonpath='{range .items[*]}{.metadata.namespace}{"/"}{.metadata.name}{","}{.status.podIP}{"\n"}{end}'

default/fah-cpu-7c66fc7948-582sr,10.244.0.11
default/fah-cpu-7c66fc7948-c9xb5,10.244.0.8
default/fah-cpu-7c66fc7948-dlm5z,10.244.0.14
default/fah-cpu-7c66fc7948-g25cb,10.244.0.10
default/fah-cpu-7c66fc7948-g2svf,10.244.0.6
default/fah-cpu-7c66fc7948-hxmfn,10.244.0.12
default/fah-cpu-7c66fc7948-jxkp8,10.244.0.13
default/fah-cpu-7c66fc7948-n7rvt,10.244.0.15
default/fah-cpu-7c66fc7948-txvpg,10.244.0.7
default/fah-cpu-7c66fc7948-vzpbz,10.244.0.9
default/mando-57fff9d5f5-rdxrx,10.244.0.3
kube-system/coredns-66bff467f8-r9g25,10.244.0.2
kube-system/coredns-66bff467f8-xfd5k,10.244.0.5
kube-system/etcd-kind-control-plane,172.18.0.2
kube-system/kindnet-g6jvd,172.18.0.2
kube-system/kube-apiserver-kind-control-plane,172.18.0.2
kube-system/kube-controller-manager-kind-control-plane,172.18.0.2
kube-system/kube-proxy-9t7tt,172.18.0.2
kube-system/kube-scheduler-kind-control-plane,172.18.0.2
local-path-storage/local-path-provisioner-bd4bb6b75-zdv22,10.244.0.4
```

Outputting in jsonpath can be pretty handy!

Though I'll still have to look up how to do it everytime. 😌
