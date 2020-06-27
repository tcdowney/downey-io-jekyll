---
layout: post
type: note
title: "Creating a Simple Kubernetes Debug Pod"
sub_title: "Premium Ubuntu Sleep Pod YAML"
color: badge-accent-3
icon: fa-code
date: 2020-06-26
categories:
  - ubuntu pod
  - sleep pod yaml
  - kubernetes
  - debug
description:
  "Sample YAML for creating a debug pod that runs Ubuntu and sleeps for a week."
---

Sometimes it can be helpful to deploy a simple Ubuntu container to a cluster when debugging. Say you just applied some new `NetworkPolicy` and want to test network connectivity between namespaces. Or maybe you added a new mutating admission webhook to inject sidecar containers and you need something to test it out with. Or maybe you just want a sandbox container to deploy and play around in.

One thing I like to do is deploy a `Pod` running Ubuntu that will let me install whatever tools I want. No need to worry about thin, [distroless](https://github.com/GoogleContainerTools/distroless) images that are so secure I can't do anything! With the Ubuntu image everything is just an `apt install` away. 😌

However, it's not as simple as running the `ubuntu` image on its own. You need to make it actually _do something_ or the container will just exit immediately. Fortunately this is easy enough... just make the container `sleep` for a long time!

I do this fairly often and hate having to write the YAML from scratch everytime. So this post will serve as a [breadcrumb](https://downey.io/blog/leaving-breadcrumbs/) for my future self to find and copy and paste from in the future. 🤞

## The YAML
The following YAML will deploy a `Pod` with a container running the [`ubuntu` Docker image](https://hub.docker.com/_/ubuntu/) that sleeps for a week. Plenty of time to do what you need!

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
  labels:
    app: ubuntu
spec:
  containers:
  - image: ubuntu
    command:
      - "sleep"
      - "604800"
    imagePullPolicy: IfNotPresent
    name: ubuntu
  restartPolicy: Always
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
  containers:
  - image: ubuntu
    command:
      - "sleep"
      - "604800"
    imagePullPolicy: IfNotPresent
    name: ubuntu
  restartPolicy: Always
EOF
```

Or you can apply the raw contents of this [Gist](https://gist.github.com/tcdowney/b8a0297241b74f94ef1fc6627f7ea69a) directly:

```console
kubectl apply -f https://gist.githubusercontent.com/tcdowney/b8a0297241b74f94ef1fc6627f7ea69a/raw/eaae035f5adca37ca00d4a49f1c1958fe3db89e3/ubuntu-sleep.yaml
```

## Using The Pod
Start up an interactive shell in the container:

```console
$ kubectl exec -it ubuntu -- /bin/bash

root@ubuntu:/#
```

Now you can install whatever you want! For example, I often install `curl` via the following:

```console
$ apt update && apt install curl -y
```

## What About Ephemeral Debug Containers?
If you've been following along with the latest Kubernetes releases, you may be aware of a new alpha feature in Kubernetes 1.18 known as [ephemeral debug containers](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#ephemeral-container). This features lets you take a **running Pod** and attach an arbitrary "debug" container that has all of the tools you might need to debug it. This is really powerful for several reasons:

1. If a Pod is misbehaving you can attach the container to it and see what's going on directly.
2. You can continue to follow best practices and publish small container images. No need to include debug utilities "just in case."
3. No need to look up this page to copy paste some YAML for a hacky Ubuntu sleep pod!

I'm really looking forward to them. However, Kubernetes 1.18 is still pretty bleeding age (at least at the time of writing this post) and the feature is still in alpha. There's also some use cases for the Ubuntu pod that it doesn't cover so this method still has some life in it yet!
