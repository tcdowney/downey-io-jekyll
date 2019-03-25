---
layout: post
type: note
title: "How to curl an endpoint protected by mutual TLS (mTLS)"
color: vapor-wave-green
icon: fa-code
date: 2019-03-24
categories:
  - programming
  - curl
  - mtls
  - mutual tls
description:
  "Example of using curl to hit an endpoint using mutual TLS authentication (mTLS)"
---
In [Cloud Foundry](https://www.cloudfoundry.org/) most internal components within the distributed system authenticate with each other via [mutually-authenticated](https://en.wikipedia.org/wiki/Mutual_authentication) TLS (we often abbreviate this to mTLS). In mutual TLS, both the client and the server present their certificates and choose to trust each other based on their trusted certificate authorities (CAs). In traditional "one-way" TLS, it's typically just the server that shares its certificate. This [video by Lyle Franklin](https://www.youtube.com/watch?v=yzz3bcnWf7M&t=4890s) does a great job of explaining it in more detail.

So while mTLS is great for security, it can make using common debugging techniques like directly testing an endpoint with `curl` trickier. You'll need the following:

1. The **CA certificate** belonging to the CA that signed the server's certificate (if it is not already included with your OS trusted certs)
1. Your **client certificate**
1. Your **client private key**

Then simply use the `--cacert`, `--key`, and `--cert` options with your curl. Here's a real world example:

```bash
curl --cacert ca.crt \
     --key client.key \
     --cert client.crt \
     https://cloud-controller-ng.service.cf.internal:9023/internal/v4/syslog_drain_urls
```
