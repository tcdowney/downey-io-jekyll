---
layout: post
type: note
title: "Creating a Super-Privileged Pod with Root and Host Namespaces"
sub_title: "Dangerous YAML for Dangerous Devs"
color: badge-accent-4
icon: fa-exclamation-triangle
date: 2020-07-01
categories:
  - ubuntu debug pod
  - kubernetes privileged pod yaml
  - kubernetes
  - debugging
description:
  "Sample YAML for creating a very priviliged Pod on Kubernetes"
---

**Disclaimer:** Obligatory warning that creating a `Pod` that runs as `root` using the host's namespaces is **not safe.** Only do this on development clusters if you have a specific goal in mind. Don't do it in production please and don't run regular workloads like this. Thanks. 🙃

Sometimes when developing on Kubernetes you may need to look deeper into what is happening on the host. In the event that you cannot easily `ssh` on to the host nodes directly. Maybe your cluster was provisioned by a coworker or comes from a managed service. Regardless the reason, in these cases it can be useful to run a super-privileged `Pod` that runs as `root` and shares the host's IPC, Network, and PID namespaces. At this point it's basically like you're running on the host itself, so tread carefully.

## Why do this at all?
So I just listed off a bunch of reasons why **you shouldn't do this**. So why would you ever _want_ to do this? Well one example might be that you're writing some complicated new `NetworkPolicies` and trying out a new [CNI implementation](https://kube.academy/lessons/an-introduction-to-cni). CNIs typically operate at the OS level and tweak low level networking configuration like `iptables` or eBPF filters.

If something is not working as expected in your dev cluster it could be helpful to view the `iptables` rules and network namespaces from the host's perspective. This is one case where a privileged debug `Pod` can come in handy.

## The YAML
The following YAML will deploy a `Pod` with a container running the [`ubuntu` Docker image](https://hub.docker.com/_/ubuntu/) that sleeps for an hour and then exits. Adjust the time as needed, but it's better to err on the shorter side of things (in case you forget about deleting it).

Before just copy pasting this, I recommend reading up on the [PodSpec docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podspec-v1-core) and [container SecurityContext docs](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#securitycontext-v1-core) to make sure you understand what we're doing here. If you don't need options like `hostIPC` or `hostPID` for your usecase, don't use them!

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
  labels:
    app: ubuntu
spec:
  # Uncomment and specify a specific node you want to debug
  # nodeName: <insert-node-name-here>
  containers:
  - image: ubuntu
    command:
      - "sleep"
      - "3600" # adjust this as needed -- use only as long as you need
    imagePullPolicy: IfNotPresent
    name: ubuntu
    securityContext:
      capabilities:
        add: ["NET_ADMIN", "SYS_ADMIN"] # add the capabilities you need https://man7.org/linux/man-pages/man7/capabilities.7.html
      runAsUser: 0 # run as root (or any other user)
  restartPolicy: Never # we want to be intentional about running this pod
  hostIPC: true # Use the host's ipc namespace https://www.man7.org/linux/man-pages/man7/ipc_namespaces.7.html
  hostNetwork: true # Use the host's network namespace https://www.man7.org/linux/man-pages/man7/network_namespaces.7.html
  hostPID: true # Use the host's pid namespace https://man7.org/linux/man-pages/man7/pid_namespaces.7.html
```

## Applying the YAML
You can apply this via the following by piping stdin to `kubectl`:

```console
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
  labels:
    app: ubuntu
spec:
  # Uncomment and specify a specific node you want to debug
  # nodeName: <insert-node-name-here>
  containers:
  - image: ubuntu
    command:
      - "sleep"
      - "3600" # adjust this as needed -- use only as long as you need
    imagePullPolicy: IfNotPresent
    name: ubuntu
    securityContext:
      capabilities:
        add: ["NET_ADMIN", "SYS_ADMIN"] # add the capabilities you need https://man7.org/linux/man-pages/man7/capabilities.7.html
      runAsUser: 0 # run as root (or any other user)
  restartPolicy: Never # we want to be intentional about running this pod
  hostIPC: true # Use the host's ipc namespace https://www.man7.org/linux/man-pages/man7/ipc_namespaces.7.html
  hostNetwork: true # Use the host's network namespace https://www.man7.org/linux/man-pages/man7/network_namespaces.7.html
  hostPID: true # Use the host's pid namespace https://man7.org/linux/man-pages/man7/pid_namespaces.7.html
EOF
```

## Using The Pod

### Viewing Kubernetes Host iptables Example
Start up an interactive shell in the container:

```console
$ kubectl exec -it ubuntu -- /bin/bash

root@ubuntu:/#
```

Now you can install whatever you want! For example, I've used this technique to debug `iptables` on the host node:

```console
$ apt update && apt install iptables -y
```

And now I can list the iptables rules from the host!
```console
root@kind-control-plane:/# iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-N KUBE-EXTERNAL-SERVICES
-N KUBE-FIREWALL
-N KUBE-FORWARD
-N KUBE-KUBELET-CANARY
-N KUBE-PROXY-CANARY
-N KUBE-SERVICES
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A INPUT -j KUBE-FIREWALL
-A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
-A FORWARD -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -j KUBE-FIREWALL
-A KUBE-FIREWALL -m comment --comment "kubernetes firewall for dropping marked packets" -m mark --mark 0x8000/0x8000 -j DROP
-A KUBE-FORWARD -m conntrack --ctstate INVALID -j DROP
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack pod source rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack pod destination rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
```

That's just one example. This technique will give you the power to do most things. But remember, this is super insecure, so don't use it unless you absolutely have to! 😬
