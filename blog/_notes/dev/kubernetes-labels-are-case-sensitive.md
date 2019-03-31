---
layout: post
type: note
title: "Kubernetes labels are case-sensitive"
sub_title: "A few examples using Kubernetes label selectors"
color: teal
icon: fa-code
date: 2019-03-30
categories:
  - programming
  - kubernetes
  - kubernetes label selectors
  - case sensitivity
description:
  "Examples demonstrating that label keys and values are case-sensitive when querying via a label selector."
---
The other day someone asked me if [Kubernetes label selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) are case insensitive
when filtering resources. I said they definitely were, but found it difficult to find examples online. Let this post be one small step toward remedying that.

## setup
I'm doing this all on [minikube](https://kubernetes.io/docs/setup/minikube/#installation) using the [hello-node](gcr.io/hello-minikube-zero-install/hello-node) container image.

I've used it to create two deployments:

```bash
$ kubectl create deployment deployment-green --image=gcr.io/hello-minikube-zero-install/hello-node
deployment.extensions "deployment-green" created

$ kubectl create deployment deployment-blue --image=gcr.io/hello-minikube-zero-install/hello-node
deployment.extensions "deployment-blue" created
```

I then added the following labels to these deployments via `kubectl label`:
```bash
$ kubectl label deployment deployment-green COLOR=green
deployment.extensions "deployment-green" labeled

$ kubectl label deployment deployment-blue COLOR=blue
deployment.extensions "deployment-blue" labeled

$ kubectl label deployment deployment-blue color=orange
deployment.extensions "deployment-blue" labeled

$ kubectl label deployment deployment-green color=orange
deployment.extensions "deployment-green" labeled

$ kubectl label deployment deployment-green environment=PRODUCTION
deployment.extensions "deployment-green" labeled

$ kubectl label deployment deployment-blue environment=production
deployment.extensions "deployment-blue" labeled
```

So these two deployments each had the following three labels:
```bash
$ kubectl get deployments --show-labels
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE       LABELS
deployment-blue    1         1         1            1           15m       COLOR=blue,app=deployment-blue,color=orange,environment=production
deployment-green   1         1         1            1           15m       COLOR=green,app=deployment-green,color=orange,environment=PRODUCTION
```

### note on label prefixes ⚠️
Label prefixes only support lowercase alphanumeric characters so you don't have to worry about this for them!

```bash
$ kubectl label deployment deployment-green INVALID.EXAMPLE.COM/hello=there
The Deployment "deployment-green" is invalid: metadata.labels: Invalid value: "INVALID.EXAMPLE.COM/hello": prefix part a DNS-1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')
```

## label selector examples

First, let's demonstrate that the key name itself is case-sensitive. Each of our deployments has an uppercase `COLOR` label along with a lowercase `color` label. The fact that these can both be applied to the same resource demonstrates the need for case-sensitivity. Let's see some label selector queries.

**Querying for lowercase `color`:**
```bash
$ kubectl get deployment --selector "color=orange"
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment-blue    1         1         1            1           24m
deployment-green   1         1         1            1           24m

$ kubectl get deployment --selector "color in (blue, green)"
No resources found.
```

**Querying for uppercase `COLOR`:**
```bash
$ kubectl get deployment --selector "COLOR=orange"
No resources found.

$ kubectl get deployment --selector "COLOR in (blue, green)"
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment-blue    1         1         1            1           25m
deployment-green   1         1         1            1           25m

$ kubectl get deployment --selector "COLOR=green"
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment-green   1         1         1            1           26m

$ kubectl get deployment --selector "COLOR=blue"
NAME              DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment-blue   1         1         1            1           26m
```

Now let's check out some examples that demonstrate the case-sensitivity of label values.

**Querying for "production" deployments:**
```bash
$ kubectl get deployment --selector "environment=PRODUCTION"
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment-green   1         1         1            1           29m

$ kubectl get deployment --selector "environment=production"
NAME              DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment-blue   1         1         1            1           29m

$ kubectl get deployment --selector "environment=Production"
No resources found.

$ kubectl get deployment --selector "environment in (PRODUCTION, production)"
NAME               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment-blue    1         1         1            1           29m
deployment-green   1         1         1            1           29m
```

As you can see above, `PRODUCTION` definitely does not equal `production` -- a sign that it's important to agree and standardize on the labels you use within your team! 🚣
