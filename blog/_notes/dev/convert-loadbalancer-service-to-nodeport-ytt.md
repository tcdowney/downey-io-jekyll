---
layout: post
type: note
title: "How to Convert a LoadBalancer Service Into a NodePort Service"
sub_title: "Transforming Kubernetes Service YAML with ytt"
color: kube-blue
icon: fa-code
date: 2020-05-31
categories:
  - kubernetes
  - ytt
  - yaml templating
  - kubernetes services
description:
  "How to programmatically convert a Kubernetes LoadBalancer Service into a NodePort Service"
---

Kubernetes [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) often include `LoadBalancer` type Services as part of their default installation config. If your IaaS supports them, `LoadBalancer` services are super convenient since they'll work with the IaaS to automatically provision a load balancer and external IP (and typically firewall rules) to make your service reachable to the world. Load balancers are seldom free, however, and for development clusters they're often either unsupported or just plain overkill.

Fortunately, a `LoadBalancer` Service is basically just a `NodePort` Service and we can use [`ytt`](https://get-ytt.io/) to programmatically convert one into the other.

Below is a `ytt` overlay that can be used for this purpose:
```yaml
#@ load("@ytt:overlay", "overlay")

#@overlay/match by=overlay.subset({"kind": "Service", "spec":{"type":"LoadBalancer"}}),expects=1
---
spec:
  #@overlay/replace
  type: NodePort
```

This defines a `ytt` [overlay](https://github.com/k14s/ytt/blob/master/docs/lang-ref-ytt-overlay.md) that looks for YAML where on `kind` matches `Service` and `spec.type` matches `LoadBalancer`. It instructs `ytt` to replace the `spec.type` of a match with `NodePort`.

Imagine that the above overlay YAML is in a file verbosely named `convert-loadbalancer-service-to-nodeport.yaml` and that we have a `LoadBalancer` Service declared in a file called `my-loadbalancer-service.yaml`.
We can use `ytt` to apply the overlay like this:

```bash
ytt -f my-loadbalancer-service.yaml -f convert-loadbalancer-service-to-nodeport.yaml
```

Why wouldn't you just edit `my-loadbalancer-service.yaml` in a text editor to be a `NodePort` Service and be done with it? Well this way you can programmatically change Kubernetes config on the fly that you might not control. When those source YAML files are updated by their owners, you don't have to recopy and update them yourself.

Below is a real world example where we use `ytt` to convert<sup>1</sup> the `LoadBalancer` Service in the NGINX Ingress Controller's deployment config and immediately `kubectl apply` it.
```bash
ytt -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml \
-f convert-loadbalancer-service-to-nodeport.yaml --ignore-unknown-comments=true \
| kubectl apply -f -
```

_<sup>1</sup> - The `--ignore-unknown-comments=true` flag is to keep `ytt` from complaining about the comments in the source YAML. As of [v0.32.0](https://github.com/vmware-tanzu/carvel-ytt/releases/tag/v0.32.0), this flag is no longer required — `ytt` now properly distinguishes between "plain YAML" and a YAML file containing templating._
