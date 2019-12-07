---
layout: post
type: note
title: "How to default null YAML values to empty strings when using ytt"
color: kube-blue
icon: fa-code
date: 2019-12-06
categories:
  - kubernetes
  - ytt
  - yaml templating
description:
  "How to default missing YAML String values to empty strings when using ytt for Kubernetes templating"
---
An example of converting null YAML values to empty strings when using [`ytt`](https://get-ytt.io/) for Kubernetes config templating. This approach uses Python's boolean short-circuiting behavior to concisely substitute empty strings for `None` values. It was inspired by [this Stack Overflow post](https://stackoverflow.com/questions/1034573/python-most-idiomatic-way-to-convert-none-to-empty-string).

If you stumbled upon this page and have no clue what `ytt` is, it's basically yet another way to template out YAML for Kubernetes. Think `helm template` but where you get to use a Python-like programming language and manipulate the YAML structures directly instead of just manipulating text.

## tl;dr
Use Python's boolean short-circuiting.

```yaml
#@ prefix = data.values.optionalPrefix or ""
labelSelector: #@ prefix + str(data.values.myKey)
```

## long form

Consider a scenario where you have a `config-template.yaml` file that generates the configuration YAML for your app and a `values.yaml` that operators can provide to supply their own values. You can do this with `ytt` via the following command:

```bash
ytt -f config-template.yaml -f values.yaml
```

Let's say you want to get fancy and allow installers of your software to be able to supply their own label selectors with an **optional** label prefix.

```yaml
#! config-template.yaml


#@ load("@ytt:data", "data")

---
labelSelector: #@ str(data.values.myPrefix) + str(data.values.myKey)
```

```yaml
#! values.yaml


#@data/values

---
myPrefix: null
myKey: "app"
```

If you allow them to simply supply `null` for the `myPrefix` value from their `values.yaml` file you'll end up generating something like this:

```yaml
labelSelector: Noneapp
```

Probably not what they intended. Instead, you can do something like this in your template:

```yaml
#! config-template.yaml


#@ load("@ytt:data", "data")

---
#@ prefix = data.values.myPrefix or ""
labelSelector: #@ prefix + str(data.values.myKey)
```

Now it will template out the following:
```yaml
labelSelector: app
```

Much better! This approach uses Python's (really [Starlark](https://docs.bazel.build/versions/master/skylark/language.html) in the case of ytt) boolean short-circuiting to skip past the falsey `NoneType` value. **Warning this also means that other falsey values become empty strings as well.** I'd recommend that you add [stricter assertions](https://get-ytt.io/#example:example-assert) if that distinction is important to you.

Here's a more realistic example where you might want to let someone configure the label prefix on a Kubernetes Service's `selector`, but not let them override the selectors completely.

```yaml
#! service-template.yaml

#! This is the way:
#@ xstr = lambda s: s or ""

#@ labelPrefix = xstr(data.values.labelPrefix)
#@ labelSelectors = {}
#@ labelSelectors[labelPrefix+ "process"] = "web"

---
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector: #@ labelSelectors    
  ports:
    - protocol: TCP
      name: http
      port: 80
      targetPort: 9001
```

```yaml
#! values.yaml


#@data/values
---
labelPrefix: k8s.downey.dev/
```

This assigns the short-circuiting logic to a lambda names `xstr` which lets us reuse it. This template + values files produces the following:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    k8s.downey.dev/process: web
  ports:
  - protocol: TCP
    name: http
    port: 80
    targetPort: 9001
```

If we were to set `~` or `null` in the values file like this:
```yaml
#! values.yaml


#@data/values
---
labelPrefix: ~
```

It would template out the selector without the prefix!

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    process: web
  ports:
  - protocol: TCP
    name: http
    port: 80
    targetPort: 9001
```

Pretty powerful stuff. To play around with `ytt` on your own, head over to https://get-ytt.io/. There is a section at the bottom containing sandbox examples where you can try it out for yourself. Good luck! 😌
