---
layout: post
type: note
title: "BOSH v2 CLI 'bosh scp' example"
color: teal
icon: fa-code
date: 2018-02-26
categories:
  - programming
  - cloud foundry
  - bosh
description:
  "Example of using the bosh scp command (bosh v2 go cli)"
---
Example of downloading the `cloud_controller_ng.log` file from and uploading a file to a Cloud Controller `api` vm using the `bosh scp` command. These examples assume you have the appropriate `BOSH_*` environment variables set to access the director and `ssh`/`scp` the `api` instance.

```bash
# download Cloud Controller logs from api vm
# FROM remote /var/vcap/sys/log/cloud_controller_ng/cloud_controller_ng.log
# TO local /tmp/ccng.log
bosh -d cf scp api:/var/vcap/sys/log/cloud_controller_ng/cloud_controller_ng.log /tmp/ccng.log

# upload a file to api vm
# FROM local ~/workspace/heap-dump.patch
# TO remote /tmp/heap-dump.patch
bosh -d cf scp ~/workspace/heap-dump.patch api:/tmp/heap-dump.patch
```

Additional `bosh scp` docs can be found within [the SSH section of the BOSH CLI docs](https://bosh.io/docs/cli-v2.html#ssh-mgmt).
