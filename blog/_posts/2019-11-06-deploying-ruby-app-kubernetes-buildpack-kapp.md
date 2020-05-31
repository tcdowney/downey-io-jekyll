---
layout: post
type: blog
title: "Simplify Kubernetes App Deployments With Cloud Native Buildpacks and kapp"
sub_title: "build your own PaaS using command line tools"
color: badge-accent-2
icon: fa-ship
date: 2019-11-06
categories:
  - kubernetes
  - k8s
  - cloud native buildpacks
  - pack cli
  - kapp
  - cloud foundry
  - ruby buildpack kubernetes
excerpt: "In recent years the Kubernetes wave has taken the software world by storm. And for good reason. Kubernetes makes it easy for developers to build robust distributed systems. It provides powerful building blocks for deploying and managing containerized workloads. This makes it an enticing platform for the sprawling microservice \"apps\" of today. In this post we'll look at simplifying app deployments on Kubernetes with Cloud Native Buildpacks and kapp."
description:
  "An introduction to deploying apps on Kubernetes with Cloud Native Buildpacks and kapp"
---
In recent years the Kubernetes wave has taken the software world by storm. And for good reason. Kubernetes makes it easy for developers to build robust distributed systems. It provides powerful building blocks for deploying and managing containerized workloads. This makes it an enticing platform for the sprawling microservice "apps" of today.

Unfortunately, all this power and flexibility carries with it enormous complexity. Kubernetes is not a PaaS (Platform as a Service) like [Heroku](https://www.heroku.com/platform) or [Cloud Foundry](https://www.cloudfoundry.org/application-runtime/). It does not build your app from source or abstract away all the gritty details. It does, however, provide many of the necessary primitives for building a PaaS.

Over the past three years, I've worked as a full-time contributor to Cloud Foundry. During that time I've come to appreciate the simplicity of the `cf push` experience.

<script id="asciicast-279484" src="https://asciinema.org/a/279484.js" async></script>

I've grown fond of pushing raw source code and [using buildpacks](https://devcenter.heroku.com/articles/buildpacks). I enjoy the ease of creating and mapping routes. I like that my app logs are a mere `cf logs`  away. That is if you're deploying a stateless 12 Factor app. If you're not -- or even if you just need to go a bit off the rails of your PaaS -- the platform can hinder more than it helps. It's these use cases where Kubernetes shines.

You don't have to completely forgo the PaaS experience you're used to, however. In this post we'll take a look at two tools: `pack` and `kapp` that help bring some of that that PaaS goodness to Kubernetes.

## Prerequisites

If you want to follow along, you'll need the following:
1. Access to a Kubernetes cluster
2. Install `kubectl` and authenticate with your cluster ([follow these docs](https://kubernetes.io/docs/tasks/tools/install-kubectl/))
3. Install `docker` ([install the Community Edition](https://docs.docker.com/v17.09/engine/installation/))
4. Install `pack` ([installation instructions](https://buildpacks.io/docs/install-pack/))
5. Install `kapp` ([installation instructions](https://get-kapp.io/))
6. Check out the sample app [`sinatra-k8s-sample`](https://github.com/tcdowney/sinatra-k8s-sample)

## Cluster Configuration

I used an inexpensive single-node managed Kubernetes cluster from Digital Ocean.  It uses a [Digital Ocean load balancer](https://www.digitalocean.com/products/load-balancer/) and, all in all, I expect it to cost about $20 a month<sup>1</sup>. I have DNS configured to direct traffic on my domain `*.k8s.downey.dev` to the load balancer's IP and the LB itself points to an NGINX server in the cluster.

I am using [ingress-nginx](https://kubernetes.github.io/ingress-nginx/) as my Ingress Controller and installed it using the GKE ("generic") installation steps [here](https://kubernetes.github.io/ingress-nginx/deploy/#gce-gke).

Since I'm using a `.dev` domain I need to have valid TLS certs since `.dev` domains are on the [HSTS preload list](https://opensource.google/projects/hstspreload) for mainstream browsers. To automate this I used [cert-manager](https://docs.cert-manager.io/en/latest/getting-started/install/kubernetes.html) with the following `ClusterIssuer`.

```yaml
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    email: email@example.com # replace with your own
    http01: {}
    privateKeySecretRef:
      name: letsencrypt-prod
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
          class: nginx
```

I loosely followed [this blog post](https://blog.heptio.com/how-to-deploy-web-applications-on-kubernetes-with-heptio-contour-and-lets-encrypt-d58efbad9f56) for the Contour Ingress Controller to set that up.

_<sup>1</sup>$20 for a k8s cluster is still nothing to sneeze at, so if you want to help me pay for it sign up with [this referral link 🤑](https://m.do.co/c/7c859c2ea14d)_

## Our App The Belafonte
<div>
<img src="https://images.downey.io/blog/belafonte.png" alt="Belafonte App">
</div>

Throughout this post we'll be deploying a simple, stateless Ruby app called `belafonte`. It is named after _The Belafonte_, the esteemed research vessel helmed by oceanographer Steve Zissou and it will carry us safely on our Kubernetes journey. If you want to follow along, simply clone the app.

```bash
git clone https://github.com/tcdowney/sinatra-k8s-sample
```

To make things a bit more interesting, `belafonte` relies on a microservice to feed it UUIDs for display. This is a bit contrived, but that's ok. We'll be deploying a small Python app called [httpbin](https://github.com/postmanlabs/httpbin) to serve this purpose.

At the end of the day, navigating to the app will return a simple webpage containing some information about the Kubernetes pod that it is deployed on as well as our artisanally crafted UUID.

## Creating Container Images Using Cloud Native Buildpacks
Kubernetes is a platform for running containers. That means to run our app, we first must create a container image for it.
Traditionally this would mean creating a `Dockerfile` to install ruby, download all of our dependencies, and more. For simple applications this can wind up causing a lot of overhead and maintenance. Fortunately, there's another option.

As I mentioned earlier, buildpacks are one of my favorite features of PaaSes. Just push up your code and let the package handle making it runnable. Lucky for us, developers from Heroku and Cloud Foundry have been working on a Cloud Native Computing Foundry project called [Cloud Native Buildpacks](https://buildpacks.io/) that lets anyone have this power.

We can use the `pack` CLI to run our code against Heroku's Ruby Cloud Native buildpack with the following command (you may need to `docker login` first to publish).

```bash
pack build downey/sinatra-k8s-sample --builder heroku/buildpacks --buildpack heroku/ruby --publish
```

This will produce an OCI container image and publish it to DockerHub (or a container registry of your choosing). Wow!

One thing to note is that, at least for the Ruby buildpack I used, I did not get a default command for the image that worked out of the box. To get it working on Kubernetes I had to first invoke the Cloud Native Buildpack launcher (`/cnb/lifecycle/launcher`) to load up the necessary environment (adding `rackup`, `bundler`, etc. to the `$PATH`). The command I ended up using on Kubernetes to run the image looked like this:

```yaml
command: ["/cnb/lifecycle/launcher", "rackup -p 8080"]
```

## The YAML Configuration
Workloads are typically deployed to Kubernetes via YAML configuration files. Within the [`deploy`](https://github.com/tcdowney/sinatra-k8s-sample/tree/f14bd4e70344c0ea511c3af67ab65535ef5cdb04/deploy) directory of [`sinatra-k8s-samples`](https://github.com/tcdowney/sinatra-k8s-sample) you'll find the necessary files for deploying the `belafonte` app, the `httpbin` "microservice" it depends on, and a file declaring the `belafonte` namespace for them all to live under.

Specifically within `deploy/belafonte` you'll find:
1. `deployment.yaml`
1. `service.yaml`
1. `ingress.yaml`

### deployment.yaml
The `deployment.yaml` defines the [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) for our app. This is where we'll tell Kubernetes how to run our app. It contains properties that declare how many instances of our app we want running, how updates should be carried out (e.g. rolling updates), and where to download the image for our container.

```yaml
...

containers:
- name: belafonte
  image: docker.io/downey/sinatra-k8s-sample:latest
  env:
  - name: POD_NAME
    valueFrom:
      fieldRef:
        fieldPath: metadata.name
  - name: POD_IP
    valueFrom:
      fieldRef:
        fieldPath: status.podIP
  - name: UUID_SERVICE_NAME
    value: httpbin
  ports:
  - containerPort: 8080
    name: http
  command: ["/cnb/lifecycle/launcher", "rackup -p 8080"]

...
```

The snippet above shows that we'll be using the image we just built with `pack` and that we're setting some environment variables on it.

### service.yaml
The `service.yaml` file contains configuration for setting up a [Kubernetes Service](https://kubernetes.io/docs/concepts/services-networking/service/). It will tell Kubernetes to allocate us an internal Cluster IP and Port that can be used to hit our app.

You can view services using `kubectl get services`. Once we deploy our app, we'll see the following services in the `belafonte` namespace.

```bash
kubectl -n belafonte get services
NAME        TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
belafonte   ClusterIP   10.245.30.60     <none>        8080/TCP   3d3h
httpbin     ClusterIP   10.245.157.166   <none>        8080/TCP   3d3h
```

### ingress.yaml
Since our cluster has an Ingress Controller installed (`ingress-nginx`), we can define an [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) via `ingress.yaml`.

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: belafonte
  annotations:
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
  namespace: belafonte
spec:
  tls:
  - secretName: belafonte
    hosts:
    - belafonte.k8s.downey.dev
  rules:
  - host: belafonte.k8s.downey.dev
    http:
      paths:
      - backend:
          serviceName: belafonte
          servicePort: 8080
```

At its most basic, this configuration instructs the ingress NGINX to direct traffic destined for `belafonte.k8s.downey.dev` to the `belafonte` service defined by `service.yaml`. Since we're using `cert-manager`, the annotations on it will instruct cert-manager and the `letsencrypt-prod` ClusterIssuer to issue and serve [LetsEncrypt](https://letsencrypt.org/) TLS certs for this domain. This part is only required if you want to support `https`, but it's simple enough so I'd recommend it.

Similar YAML config exists for `httpbin` in the `deploy/httpbin` directory (minus the Ingress since we do not want it externally reachable).

## Installing the App with kapp
<script id="asciicast-279697" src="https://asciinema.org/a/279697.js" async></script>

All of that YAML declaritively represents the desired state we want our applications to be in. If you just `kubectl apply -f <file>` every file in that `deploy` directory you'll get a running `belafonte` app and an `httpbin` microservice to back it. Unfortunately, `kubectl apply` can be a pretty blunt tool. It's hard to tell what it is going to do without hand inspecting each YAML file. Options like `--dry-run` and commands like `kubectl diff` exist to help improve things, but those used to doing `git push heroku` or `cf push` may still desire a nicer UX.

This is where the [Kubernetes Application Management Tool](https://get-kapp.io/), or `kapp`, comes in. I like `kapp` because it provides something a bit closer to that PaaS experience _and_ you don't have to install anything special on the k8s cluster.

### Deploying
With `kapp` we can `kapp deploy` our entire deploy directory and deploy the app all in one go. If you're following along, go ahead and run `kapp deploy -a belafonte -f deploy` and check it out!

```bash
$ kapp deploy -a belafonte -f deploy


Changes

Namespace  Name       Kind        Conds.  Age  Op      Wait to    Rs  Ri
(cluster)  belafonte  Namespace   -       -    create  reconcile  -   -
belafonte  belafonte  Deployment  -       -    create  reconcile  -   -
^          belafonte  Ingress     -       -    create  reconcile  -   -
^          belafonte  Service     -       -    create  reconcile  -   -
^          httpbin    Deployment  -       -    create  reconcile  -   -
^          httpbin    Service     -       -    create  reconcile  -   -

Op:      6 create, 0 delete, 0 update, 0 noop
Wait to: 6 reconcile, 0 delete, 0 noop

Continue? [yN]:
```

It will show what changes it expects to do and prompt first before applying. It then applies the changes, tracks all the resources that were created as part of this "app" (as specified per the `-a` flag), and will wait until everything is running (by checking the `status` of the resources) before exiting. It is even aware of some of the typical ordering requirements of config. For example, it is smart enough to create `namespaces` and CRDs before applying config that might depend on them. It stores this logical "app" definition within a `ConfigMap` so the definition of the app is persisted on the Kubernetes api. You can switch computers or come back days later and `kapp` will still recognize your app.

### Fetching Logs
To be fair, getting logs with `kubectl` isn't too tough. Just `kubectl -n belafonte logs -l app=belafonte -f` and we can stream them out for pods with the `app=belafonte` label. As the number of apps you want to stream logs for grows, however, that label selector can become cumbersome. Streaming logs is a bit friendlier with `kapp`. Just run `kapp logs -a belafonte -f` and you'll stream logs from every pod that `kapp` deployed. In our case that's both `httpbin` and `belafonte`.

```bash
$ kapp logs -a belafonte -f


# starting tailing 'httpbin-57c4c9f6c6-662rh > httpbin' logs
# starting tailing 'belafonte-ccc57688b-pqbkj > belafonte' logs
httpbin-57c4c9f6c6-662rh > httpbin | [2019-11-07 05:22:13 +0000] [1] [INFO] Starting gunicorn 19.9.0
httpbin-57c4c9f6c6-662rh > httpbin | [2019-11-07 05:22:13 +0000] [1] [INFO] Listening at: http://0.0.0.0:8080 (1)
httpbin-57c4c9f6c6-662rh > httpbin | [2019-11-07 05:22:13 +0000] [1] [INFO] Using worker: sync
httpbin-57c4c9f6c6-662rh > httpbin | [2019-11-07 05:22:13 +0000] [8] [INFO] Booting worker with pid: 8
# ending tailing 'httpbin-57c4c9f6c6-662rh > httpbin' logs
belafonte-ccc57688b-pqbkj > belafonte | [2019-11-07 05:22:15] INFO  WEBrick 1.4.2
belafonte-ccc57688b-pqbkj > belafonte | [2019-11-07 05:22:15] INFO  ruby 2.5.5 (2019-03-15) [x86_64-linux]
belafonte-ccc57688b-pqbkj > belafonte | [2019-11-07 05:22:15] INFO  WEBrick::HTTPServer#start: pid=1 port=8080
```

### Deleting the Apps

When you're done experimenting, `kapp` makes cleaning up convenient as well. Simply run the following to delete everything that was deployed.

```bash
$ kapp delete -a belafonte


Changes

Namespace  Name       Kind        Conds.  Age  Op      Wait to  Rs  Ri
belafonte  belafonte  Deployment  2/2 t   22s  delete  delete   ok  -
^          httpbin    Deployment  2/2 t   22s  delete  delete   ok  -

Op:      0 create, 2 delete, 0 update, 0 noop
Wait to: 0 reconcile, 2 delete, 0 noop

Continue? [yN]:
```

One gotcha, though, in the case of the LetsEncrypt certs that `cert-manager` provisioned for us. LetsEncrypt rate limits certificate requests for a particular domain to 50 per month. If you plan on repeatedly churning these certs (like I did while writing this post) you'll quickly hit those limits. Luckily `kapp` supports filters so you could do something like `kapp delete -a belafonte --filter-kind=Deployment` to only delete the deployments and leave the `Ingress` definitions (and associated certs) around.

## Wrapping Up

So if you enjoy the app developer experience of a Platform, but require the power and flexibility of Kubernetes these tools are definitely worth a look. If you're interested in learning more, I recommend checking out the following resources:

* [Heroku post on building Docker images with Cloud Native Buildpacks](https://blog.heroku.com/docker-images-with-buildpacks)
* [TGI Kubernetes 079 - ytt and kapp](https://www.youtube.com/watch?v=CSglwNTQiYg)

Happy sailing! ⛵️
