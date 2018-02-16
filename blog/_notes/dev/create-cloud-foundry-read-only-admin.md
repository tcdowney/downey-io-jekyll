---
layout: post
type: note
title: "Creating a Cloud Foundry Read-only Admin User"
color: green
icon: fa-code
date: 2018-02-15
categories:
  - programming
  - cloud foundry
---
I wanted to create a section of my site where I can drop off little one-off posts or snippets mostly for my own personal (future) use. This is the inaugural note! 😁

My personal flow for creating a "readonly admin" user on a [bosh-lite](https://github.com/cloudfoundry/bosh-lite) with a director that stores secrets in CredHub while developing Cloud Foundry:

```bash
export BOSH_LITE_DOMAIN=<some-bosh-lite-domain>
export CREDHUB_SERVER="<credhub-server-address>:<credhub-port>"
export CREDHUB_CLIENT=<credhub-client-name>
export CREDHUB_SECRET=<credhub-client-secret>

# Log in to CredHub
credhub login --skip-tls-validation # bosh-lites typically have self-signed certs

# Fetch password for cf admin user from CredHub and authenticate with UAA
cf_admin_pass=$(credhub get --name '/bosh-lite/cf/cf_admin_password' --output-json | jq -r '.value')
cf api https://api.${BOSH_LITE_DOMAIN} --skip-ssl-validation
cf auth admin $cf_admin_pass

# Create user to be readonly admin
cf create-user readonly-admin <password>

# Fetch UAA admin client credentials from CredHub
uaa_secret=$(credhub get --name '/bosh-lite/cf/uaa_admin_client_secret' --output-json | jq -r '.value')

# Authenticate with UAA
uaac target uaa.${BOSH_LITE_DOMAIN} --skip-ssl-validation
uaac token client get admin -s $uaa_secret

uaac group add cloud_controller.admin_read_only # if it does not already exist
uaac member add cloud_controller.admin_read_only readonly-admin
```

The following scripts automate this a bit, but I don't always have a workstation set up to use them handy:
* [target-uaa](https://github.com/cloudfoundry/capi-release/blob/67c59ab59c1f1f7cebab3969e500da6ed4a6549b/scripts/target-uaa)
* [target-cf](https://github.com/cloudfoundry/capi-release/blob/67c59ab59c1f1f7cebab3969e500da6ed4a6549b/scripts/target-cf)

More detailed docs:
* [https://docs.cloudfoundry.org/uaa/uaa-user-management.html#admin-read-only](https://docs.cloudfoundry.org/uaa/uaa-user-management.html#admin-read-only)
