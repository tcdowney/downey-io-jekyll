---
layout: post
type: blog
title: "Using kbld to Rapidly Iterate on Kubernetes Deployed Apps"
sub_title: "speeding up the Docker image build-push-deploy cycle"
color: badge-accent-2
icon: fa-ship
date: 2020-05-27
categories:
  - kubernetes
  - docker
  - buildpacks
  - kbld
  - pack
  - devops
excerpt:
  "When creating applications that extend or interact with Kubernetes, there are times when it's necessary to deploy and develop against a real K8s cluster. While Kubernetes makes it trivial to apply and roll out new changes, the building and pushing new dev Docker images for your application can be a rigamarole. On top of that, you also have to remember to configure the imagePullPolicyfor your containers to Always. Fortunately, there is a tool that can help solve all of these problems: kbld. The kbld CLI (pronounced \"k build\") assists with all things around image building and pushing for Kubernetes."
description:
  "How to use kbld to rapidly iterate when building, pushing, and deploying Docker images to Kubernetes"
---

When creating applications that extend or interact with Kubernetes, there are times when it's necessary to deploy and develop against a real K8s cluster. While Kubernetes makes it trivial to apply and roll out new changes, the building and pushing new dev Docker images for your application can be a rigamarole. On top of that, you also have to remember to configure the [`imagePullPolicy`](https://kubernetes.io/docs/concepts/containers/images/#updating-images) for your containers to `Always`. Otherwise, who knows if the `node` your app ends up running on has the old image cached!

Fortunately, there is a tool that can help solve all of these problems. The [`kbld`](https://get-kbld.io/) CLI (pronounced "k build") assists with all things around image building and pushing for Kubernetes. It's under active development so refer to [the kbld site](https://get-kbld.io/) for the most up to date feature set, but I'm a fan of its ability to do the following:

1. Know where my source code to build lives
2. Build an OCI image (using Docker or [Cloud Native Buildpacks](https://buildpacks.io/))
3. Tag the image and push it to the registry of my choice (local registry for KIND, DockerHub, GCR, etc.)
4. Find references to the image in Kubernetes deployment YAMLs and replace vague references with image digests for deterministic deployments

I'm less of a fan, however, of its terse documentation. So in this post, I'm going to show how I use `kbld` to build Docker images for my projects.

## Understanding kbld Configuration

Like most things in the Kubernetes ecosystem, the `kbld` CLI is configured by YAML files. There are several options here, but the two main YAML objects I use are `Sources` and `ImageDestinations`.

### Sources
```yaml
apiVersion: kbld.k14s.io/v1alpha1
kind: Sources
sources:
- image: image-repository/image-name
  path: /path/to/source/code
  pack:
    build:
      builder: heroku/buildpacks:18
```


A `Sources` object declares the images that kbld should be responsible for building. It includes information about the `path` for the source code of an image as well as configuration for the image builder (`docker` or `pack`).

### ImageDestinations
```yaml
apiVersion: kbld.k14s.io/v1alpha1
kind: ImageDestinations
destinations:
- image: image-repository/image-name
  newImage: docker.io/image-repository/image-name
```

`ImageDestinations` tell kbld how it should tag and push the images that it has built. It's a pretty simple resource, and I was surprised at first that there was nothing about authentication here for private registries. That config, however, comes in either through your Docker config or as environment variables. See [these kbld authentication docs](https://github.com/k14s/kbld/blob/master/docs/auth.md) for more information on that.

### Are these Kubernetes Resources?
An astute developer might recognize that these kbld resources look suspiciously similar to Kubernetes resource objects and wonder if there are any [CRDs](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) involved here. That's not the case, though. The similarities are purely superficial, and these resources are used client-side directly by the `kbld` CLI.

As always, refer to [the kbld config documentation](https://github.com/k14s/kbld/blob/master/docs/config.md) for the latest on what is possible.

## How to Use kbld

The following examples refer to a simple Go app called [mando](https://github.com/tcdowney/mando) that will be built and deployed to Kubernetes using `kbld`.

### Building an app with kbld using a Dockerfile
If you wish to follow along, you'll need the following:
1. [Install docker](https://docs.docker.com/get-docker/)
2. Sign up for a free [DockerHub account](https://hub.docker.com/) or have access to a different image registry
3. [Install kbld](https://k14s.io/)
4. Have access to a Kubernetes cluster and `kubectl` if you want to deploy

To start, since we'll be publishing to an OCI image registry, we'll first need to [authenticate](https://github.com/k14s/kbld/blob/master/docs/auth.md). Since I'm pushing my images to DockerHub that means I just need to `docker login`.

For the following, I'll be working off of the [`kbld-dockerfile-example` branch](https://github.com/tcdowney/mando/tree/kbld-dockerfile-example) of my test app repo.

In this repo, I have an example `Deployment` for Kubernetes in the `deploy` directory and the kbld files within the `build` directory.

```yaml
---
apiVersion: kbld.k14s.io/v1alpha1
kind: Sources
sources:
- image: downey/mando
  path: .
```

Here I've configured kbld to build my image, `downey/mando`, using the code and `Dockerfile` at the root of my repository.

```yaml
---
apiVersion: kbld.k14s.io/v1alpha1
kind: ImageDestinations
destinations:
- image: downey/mando
  newImage: docker.io/downey/mando
```

This `ImageDestinations` configuration tells kbld to tag and push my image to DockerHub at `docker.io/downey/mando`.

Now to use this configuration, in the root of the app directory we can run:

```console
kbld -f build -f deploy
```

We will then see kbld work its magic. It will:
1. Build the `mando` app using its `Dockerfile`
2. Push it to DockerHub
3. Update the references to the image in our Kubernetes `Deployment` to use the digest for the image we just built
4. Output the Kubernetes YAML with all changes

We can then either write this output to a file or deploy it directly to Kubernetes:

```console
kbld -f build -f deploy | kubectl apply -f -
```

It might not seem like much at first. But after dozens of cycles of `docker build`, `docker push`, updating Kubernetes config to point to a new tag, and deploying, kbld can end up saving a bunch of time!

Where I _really_ find kbld useful though, is with Cloud Native Buildpacks.

### Building an app with kbld using Buildpacks
For this section I'll be working off of the [`kbld-pack-example` branch](https://github.com/tcdowney/mando/tree/kbld-pack-example) of my test app repo. If you're unfamiliar with the concept of buildpacks, I'd encourage you to [learn more about them](https://blog.heroku.com/buildpacks-go-cloud-native) or check out my blog post on [deploying apps to Kubernetes with Buildpacks](https://downey.io/blog/deploying-ruby-app-kubernetes-buildpack-kapp/).

Using Buildpacks instead of a Dockerfile to build is simple with `kbld`. The flow is pretty much the same -- instead of a Dockerfile, we will use the [pack](https://buildpacks.io/docs/install-pack/) CLI (install it if you haven't already) and make some minor tweaks to our `Sources` YAML.

```yaml
---
apiVersion: kbld.k14s.io/v1alpha1
kind: Sources
sources:
- image: downey/mando
  path: .
  pack:
    build:
      builder: cloudfoundry/cnb:tiny
```

Here we tell kbld which ["builder"](https://buildpacks.io/docs/concepts/components/builder/) to use. I'm using the `cnb:tiny` builder since it's optimized for creating "distroless" lightweight images for Go binaries. Perfect for this use case. If you're unsure which builder to use, you can always run `pack suggest-builders` to get an up-to-date list of builders from Cloud Foundry and Heroku.

Anyways, as I said earlier, the flow is the same as before. To build and deploy, just run:

```console
kbld -f build -f deploy | kubectl apply -f -
```

The `kbld` CLI will now build using `pack` instead of `docker`! Since I use the `pack` CLI pretty infrequently, I'm more than happy to hand over the reigns to `kbld` and let it orchestrate the build and push.

## Summary
Well that's about it. If you've gotten this far, hopefully this post has helped demystify some of the basic use cases for `kbld` and how it can help streamline the Docker image push-build-deploy flow. If you're looking to learn more, check out the [kbld docs](https://github.com/k14s/kbld/blob/master/docs/README.md) or join the `#k14s` channel on [Kubernetes Slack](https://slack.kubernetes.io/). Good luck! 🌝
