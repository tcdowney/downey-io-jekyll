---
layout: post
type: blog
title: "Producing a Software Bill of Materials the Easy Way"
sub_title:  "Securing your supply chain with SBOMs and Cloud Native Buildpacks"
color: badge-accent-3
icon: fa-list
date: 2022-06-05
categories:
  - sbom
excerpt:
 "A Software Bill of Materials, aka an SBOM, is a key component in software supply chain security. SBOMs are really just a fancy term for a nested list of all of the dependencies that make up a piece of software. There are a number of different utilities that can generate SBOMs for container images after the fact, but I like to get them for free without doing any additional work. That's where Cloud Native Buildpacks come in."
description:
  "How to generate a Software Bill of Materials file for your code using Cloud Native Buildpacks."
---

It seems like every week we hear that there is a new vulnerability in some core dependency. Or maybe yet another package we all depend on has been hacked (maintainers, please enable two-factor auth!!). The only thing we can do as developers in these cases is patch our software back to a safe version of the dependency as soon as possible. That's easier said than done, however. For many of us even just knowing what dependencies our deployed code is using is a struggle. 

That's where having a [Software Bill of Materials](https://www.cisa.gov/sbom) comes in.

## What is an SBOM?

A Software Bill of Materials, aka an SBOM, is a key component in software supply chain security. SBOMs are really just a fancy term for a nested list of all of the dependencies that make up a piece of software. There are a variety of different formats such as [Syft JSON](https://github.com/anchore/syft), [SPDX](https://spdx.dev/), and [Cyclone DX](https://cyclonedx.org/specification/overview/). Others do a [much better job at explaining their content and differences](https://fossa.com/blog/software-bill-of-materials-formats-use-cases-tools/), but at their core all SBOMs contain a list of dependencies and information about each dependency such as its name, version, supplier, cryptographic hashes (checksums), and other unique identifiers. And even if you don't personally care about SBOMs (even though you should!!), the US Federal Government sure does. There is an [executive order](https://www.federalregister.gov/documents/2021/06/02/2021-11592/software-bill-of-materials-elements-and-considerations) mandating that all software sold to the US Federal Government include them. So how do we go about generating a Software Bill of Materials for our code?


## Producing SBOMs with Buildpacks

There are a number of different utilities that can generate SBOMs for container images after the fact (such as [Syft](https://github.com/anchore/syft)), but I like to get them for free without doing any additional work. 🙃 Plus, it's really nice to generate them at build time since if you're using a compiled language and producing minimal, distroless images it can be difficult to even determine what went into that binary.

That's where [Cloud Native Buildpacks](https://buildpacks.io/) come in.

I first became a fan of buildpacks after I pushed my first Rails app to Heroku nearly a decade ago and have continued to appreciate them throughout my time as a [Cloud Foundry](https://www.cloudfoundry.org/) contributor. Cloud Native Buildpacks (CNBs) take all that is nice about buildpacks from those ecosystems and bring them to the world of containers and Kubernetes. Using the `pack` CLI I can quickly build a container image capable of running my source code without having to maintain a `Dockerfile` and have it come with a whole load of best practices already baked in. Among those is the fact that many CNBs have first-class support for SBOMs [baked in](https://buildpacks.io/docs/features/bill-of-materials/). By simply building your app with one of these buildpacks it will include a layer in the resulting image that contains Syft, SPDX, and Cyclone DX formatted SBOMs which you can easily access with the `pack sbom download` command. By baking the SBOM into the image, you can keep both of them together and even sign the image to know that it hasn't been tampered with and exactly what version of the code it belongs to.

Sound cool? While the [buildpack docs](https://buildpacks.io/docs/features/bill-of-materials/) cover how to do it, let's do a quick demonstration with a real codebase.

## Demo

I'll be using the [`pack`](https://buildpacks.io/docs/tools/pack/) CLI to build my images and the [`dive`](https://github.com/wagoodman/dive) CLI to inspect them in more depth. Both utilities were readily available for my M1 Mac via `brew`.

The codebase I'm using is the Cloud Foundry [Korifi](https://github.com/cloudfoundry/korifi) project -- a set of Golang Kubernetes controllers.

So first thing's first, we've got to clone the repo and `cd` into its directory. Next (assuming you haven't already configured `pack`), set the default builder:

```console
pack config default-builder paketobuildpacks/builder:base
```

This basically is telling `pack` that you want to use the core set of Paketo Cloud Native Buildpacks with a versatile base OS image. Since this is a Golang project I could have chosen the `tiny` builder (similar to [distroless](https://github.com/GoogleContainerTools/distroless)), but the `base` builder is more flexible and supports other languages that I use frequently so I like to keep it as my default builder.

Next, build the project! Since Korifi contains the code for other components of this project, we need to set the `BP_GO_TARGETS` to build the "controllers" binary specifically.

```console
pack build korifi-controllers --env BP_GO_TARGETS="./controllers"
```

It will take a bit of time to build, but once it's done that's it! We've now got a runnable container image for our Kubernetes controllers with some SBOMs baked in. The `pack` CLI let's us extract those SBOMs with the following command:

```console
pack sbom download korifi-controllers -o /tmp/korifi-controllers-sbom
```

This outputted them to the temp directory I specified with `-o`:

```
ls /tmp/korifi-controllers-sbom/layers/sbom/launch/paketo-buildpacks_go-build/targets
sbom.cdx.json  sbom.spdx.json sbom.syft.json
```

As you can see, it output SBOMs in the three main formats: Cyclone DX, SPDX, and Syft.

```json
{
 "artifacts": [
  {
   "id": "f81915beaeb286e0",
   "name": "cloud.google.com/go/compute",
   "version": "v1.6.1",
   "type": "go-module",
   "foundBy": "go-module-binary-cataloger",
   "locations": [
    {
     "path": "controllers"
    }
   ],
   "licenses": [],
   "language": "go",
   "cpes": [
    "cpe:2.3:a:go:compute:v1.6.1:*:*:*:*:*:*:*"
   ],
   "purl": "pkg:golang/cloud.google.com/go/compute@v1.6.1",
   "metadataType": "GolangBinMetadata",
   "metadata": {
    "goCompiledVersion": "go1.18.1",
    "architecture": "amd64"
   }
  },
  {
   "id": "24aa113dfb7228c8",
   "name": "code.cloudfoundry.org/eirini-controller",
   "version": "v0.3.0",
   "type": "go-module",
   "foundBy": "go-module-binary-cataloger",
   "locations": [
    {
     "path": "controllers"
    }
   ],
   "licenses": [],
   "language": "go",
   "cpes": [],
   "purl": "pkg:golang/code.cloudfoundry.org/eirini-controller@v0.3.0",
   "metadataType": "GolangBinMetadata",
   "metadata": {
    "goCompiledVersion": "go1.18.1",
    "architecture": "amd64"
   }
  },
...
```

As I mentioned earlier, the SBOMs are a part of the image itself so there is no doubt what they belong to and no need to store them separately.

You can see them using the `dive` utility I mentioned earlier:

```
dive korifi-controllers
```

This is a really cool utility in general because it lets you view all of the files that make up each layer in a container image. Here we can use it to navigate to one of the smaller layers at the end that contains our SBOMs.

<div>
<img src="https://images.downey.io/blog/korifi-controllers-dive-screenshot.png" alt="Inspecting the SBOM layers of an image using dive.">
</div>

So that's cool. It also means that if you sign your images (always a good idea) that the SBOMs is conveniently signed as well and this will make it tamper resistant.

## Vulnerability Scanning our SBOMs

So what else can we do with those SBOM files? We can scan them for vulnerabilities! For this we can use the [`grype`](https://github.com/anchore/grype) CLI (like Syft, it is also built by Anchore) and point it at the SBOM files we downloaded earlier.

```console
grype sbom:/tmp/korifi-controllers-sbom/layers/sbom/launch/paketo-buildpacks_go-build/targets/sbom.syft.json --only-fixed
```

```console
 ✔ Vulnerability DB        [no update available]
 ✔ Scanned image           [0 vulnerabilities]

[0000]  WARN some package(s) are missing CPEs. This may result in missing vulnerabilities. You may autogenerate these using: --add-cpes-if-none
No vulnerabilities found
```

Grype is really cool and something I'd recommend running in CI periodically against your SBOMs/images. There's always going to be CVEs out there so you can use the `--fail-on` flag to specify what level you'd like to fail on and the `--only-fixed` flag to only report CVEs that you can take action on.

## SBOMs are Cool

Well there you have it. Software Bill of Materials are currently all the rage when it comes to securing your software supply chain and as we've seen, they're not too difficult to produce! I hope you learned something new about buildpacks and SBOMs from this post, and even if you haven't, thanks for sticking around this long! 😊
