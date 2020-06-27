---
layout: post
type: note
title: "Creating a Simple Kubernetes Debug Pod"
sub_title: "Ubuntu Sleep Pod YAML"
color: badge-accent-3
icon: fa-code
date: 2020-06-26
categories:
  - ubuntu pod
  - sleep pod yaml
  - kubernetes
  - debug
description:
  "Sample YAML for creating a debug pod that runs Ubuntu."
---

Sometimes it can be helpful to deploy a simple Ubuntu container to a cluster when debugging. Say you just applied some new `NetworkPolicy` and want to test network connectivity between namespaces. Or maybe you added a new mutating admission webhook and want to see that it installs the sidecar container you expected. One thing I like to do is deploy a `Pod` running Ubuntu that will let me install whatever tools I want. No need to worry about thin, [distroless](https://github.com/GoogleContainerTools/distroless) images that are so secure I can't do anything! With the Ubuntu image everything is just an `apt install` away!

However, you need to make it actually _do something_ or the container will just exit immediately. This is easy enough... just make it `sleep` for a long time! However I find myself doing this fairly frequently... and I hate having to write the YAML from scratch every time.

This note is a [breadcrumb](https://downey.io/blog/leaving-breadcrumbs/) for myself to find and give me something to copy and paste from in the future. 🤞

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

## Why Not Ephemeral Debug Containers?
One thing I'd like to note. Kubernetes 1.18+ introduces a new alpha feature called [ephemeral debug containers](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#ephemeral-container). This will let you attach a debug container that has all the tools you want to a **running Pod**. That's really cool and can cover many of the debugging use cases (plus some additional ones too!) for an Ubuntu sleep Pod. However, that's pretty bleeding edge still since 1.18 was just released a few months ago (March 25, 2020).
