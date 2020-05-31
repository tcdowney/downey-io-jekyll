---
layout: post
type: blog
title: "How to Deploy a Static Website with Cloud Foundry"
sub_title:  "Deploying a Jekyll Site with a Custom Domain Name and Cloudflare SSL"
color: badge-accent-2
icon: fa-code
date: 2017-09-17
categories:
  - blogging
  - static site hosting
  - jekyll
  - cloud foundry
  - staticfile buildpack
excerpt:
  "When it comes to hosting a static website there are many options available ranging from the free (and somewhat limiting) Github Pagesto deploying directly to an Amazon S3 bucket to self-hosting NGINX on Digital Ocean. For those looking for more flexibility than what Github and S3 can provide, but want to avoid the hassle of maintaining a full virtual machine on Digital Ocean, a managed Cloud Foundry can be a good option.  This post will cover how to use the Cloud Foundry Staticfile buildpack to deploy to a public Cloud Foundry PaaS and wire it up with a custom domain name and Cloudflare SSL."
description:
  "How to deploy a static website on to Cloud Foundry using the Staticfile buildpack and hook it up with a custom domain name and Cloudflare SSL."
---

I've been a fan of static websites for a while now and although I've been tempted at times to switch back to Wordpress or Ghost, I [always end up coming back]({{ site.baseurl }}{% post_url 2017-05-20-jekyll-to-hugo-to-ghost-to-jekyll %}).  One thing I do miss about having a "real" server, though, is the added control it gives your site on handling the inbound request. For example this site is currently hosted on Amazon S3 sitting behind CloudFront. I decided one day to get rid of the useless splash page sitting at the root and wanted to direct folks to `/blog` directly. Since I didn't have a real server at my control, however, this meant I had to use some [hacky combo of meta tags with Javascript as a fallback](https://github.com/tcdowney/downey-io-jekyll/blob/3eb580ba09b81b1255439e4c0875f344bd0b87f6/blog/index.html) to beseech the browsers to redirect. It's not perfect by any means and there is some jitteriness, but it gets the job done... for now.

At the time I thought about migrating over to a budget VPS host like [Digital Ocean](https://www.digitalocean.com/) or [Vultr](https://www.vultr.com/), but really didn't want the hassle of having to actual maintain a production server (security patching, installing updates, etc.).  But what if there was a way to get more control over my static site, but with minimal continued maintenance by myself?

This is where Cloud Foundry comes in.

## What is Cloud Foundry

[Cloud Foundry](https://www.cloudfoundry.org/) is an open source application platform that is mainly used by enterprises to self-host their hoards of Java and .NET apps both on premise and across the different cloud providers (e.g. Amazon Web Services, Google Cloud Platform, Azure, etc.). There are a number of public Cloud Foundry offerings available for hosting our site such as [IBM BlueMix](https://www.ibm.com/cloud-computing/bluemix/) and [Pivotal Web Services](https://run.pivotal.io/) (PWS). For this tutorial I'm going to be using Pivotal Web Services since I used to work on it at Pivotal (still at Pivotal, but now work on the [Cloud Controller](https://github.com/cloudfoundry/cloud_controller_ng) CF component) and am more familiar with it. Plus with the amount of resources that a static site consumes, it will take months to burn down the trial credit.

Apart from the PWS account creation process, the steps below should also apply to any deployment of Cloud Foundry, such as BlueMix, and a static site should run comfortably under their free tier as well.

## Getting Started

First, you'll need to [create a Pivotal Web Services](http://run.pivotal.io/) account.  You'll get some trial application credit upon signing up which will cover hosting a small-footprint static site for a heck of a long time. During the sign up process you will create an "Org" to which you will deploy your site.

Once you've got an account, go ahead and [install the CF CLI](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html) for your platform.

Next, target the PWS API with your CLI:

{% highlight bash %}
$ cf api api.run.pivotal.io
{% endhighlight %}

Then log in with the username and password you signed up with and target the organization that you just created:
{% highlight bash %}
$ cf login # you will be prompted for your username and password
$ cf target -o ORGANIZATION_NAME
{% endhighlight %}

## Deploying a Sample Jekyll Site

Now, as an example, we will deploy [this sample Jekyll site](https://github.com/tcdowney/jekyll-cf-static-site-example). Feel free to follow along and deploy it yourself to get a feel for the process.

{% highlight bash %}
$ git clone https://github.com/tcdowney/jekyll-cf-static-site-example.git
$ cd jekyll-cf-static-site-example
{% endhighlight %}

Within this directory you'll find two files unique to deploying a static site on Cloud Foundry: the `Staticfile` and a `manifest.yml` file.

The `Staticfile` contains commands that the Staticfile buildpack will use to configure your site and the NGINX server that it will sit behind. Our sample Jekyll site's simply tells it to use the `_site` directory as its root path and tells NGINX to include some additional configuration files. In the case of our example site, it is including a file called `error404.conf` that is used to [add a custom 404 error page]({{ site.baseurl }}{% post_url 2017-09-22-cloud-foundry-staticfile-buildpack-custom-404-error %}).

{% highlight yaml %}
# Staticfile
root: _site
location_include: includes/*.conf
{% endhighlight %}

The `Staticfile` allows you to do some powerful things such as serving gzipped assets and requiring basic auth password protect. You can even provide a custom `nginx.conf` file to configure the embedded NGINX server. This can be handy when setting up custom redirect rules and url parsing. See [these docs](https://docs.cloudfoundry.org/buildpacks/staticfile/index.html#config-options) for a full list of the available `Staticfile` configuration options.

The `manifest.yml` file is used by the CLI to remember configuration for the app. These application manifests typically contain information regarding how much memory the app should have, what routes it should use, how many instances of the app should be deployed, and more.  Check out the [application manifest docs](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html) for more information.
This is what our sample site's looks like:

{% highlight yaml %}
# manifest.yml
applications:
- name: my-static-site
  memory: 32M
  instances: 2
  buildpack: https://github.com/cloudfoundry/staticfile-buildpack
  random-route: true
{% endhighlight %}

This manifest will instruct the system to deploy a static site named `my-static-site` with two instances both with 32 MB of memory available. We ask for a `random-route` for testing purposes since it's not clear what routes have been taken.

Now go ahead and push this site your your org!
{% highlight bash %}
$ cf push
{% endhighlight %}

The app will stage and be available at a random route on the `cfapps.io` domain. Your site should look similar to this [example deployment](https://jekyll.cfapps.io).

Updating the site is just as simple. If you happen to have a Ruby environment and Jekyll set up, feel free to add a new post or edit the existing sample post in `_posts/2017-09-17-welcome-to-jekyll.markdown`.

While we're at it, let's also edit the `manifest.yml` file to scale down our site a bit and conserve resources since it really doesn't need to be _that_ highly available.

{% highlight yaml %}
# editing manifest.yml
applications:
- name: my-static-site
  memory: 20M
  instances: 1
  buildpack: https://github.com/cloudfoundry/staticfile-buildpack
  random-route: true
{% endhighlight %}

This change will scale the site down to a single instance with only 20 megabytes of RAM the next time we run `cf push`. To deploy your changes just run `jekyll build` to regenerate the `_site` folder and `cf push` again. If you don't have Jekyll set up, don't worry.  For the purposes of this demo just edit the files in the `_site` directory directly. Now, let's kick off that build and deploy:

{% highlight bash %}
$ jekyll build # or optionally edit _site manually
$ cf push
{% endhighlight %}

The site will restage and you'll be able to see your changes live at the route you were given earlier. Running `cf app my-static-site` will confirm that it has been scaled down to a single instance and will display how much of the 20 MB of memory it's actually using.

## Mapping a Custom Domain

Great, so we've now deployed a static site to our Cloud Foundry organization! The only problem is it's using a randomly generated url and it's only responding to traffic over plain old HTTP.

Adding new domains is simple enough. I recommend following the [official docs around adding a private domain](https://docs.run.pivotal.io/devguide/deploy-apps/routes-domains.html#private-domains), but if that's too much to read, you basically just need to run the following CLI command:

{% highlight bash %}
$ cf create-domain ORG_NAME DOMAIN_NAME
{% endhighlight %}

Here's how I would add this domain to my org:
{% highlight bash %}
$ cf create-domain downey-org downey.io
{% endhighlight %}

Then you can just use the map-route command to map it to your app:

Here's how I would add this domain to my org:
{% highlight bash %}
$ cf map-route APP_NAME DOMAIN_NAME -n SUBDOMAIN
{% endhighlight %}

For example, this would tell the Cloud Foundry router to route all inbound requests to `blog.downey.io` to my app named `blog-app`:
{% highlight bash %}
$ cf map-route blog-app downey.io -n blog
{% endhighlight %}

Now you may be wondering, how does Cloud Foundry actually know I own this domain and if you try these commands out, you'll notice that requests aren't actually hitting your app. You'll need to [configure these DNS settings](https://docs.run.pivotal.io/devguide/deploy-apps/routes-domains.html#domains-dns) to get things wired up correctly.

## Adding SSL/TLS Support
Unfortunately, in order to get your own SSL/TLS certificates onto PWS you'll have to sign up for the [Pivotal SSL Service](https://docs.run.pivotal.io/marketplace/pivotal-ssl.html) which has a monthly fee. If you're like me though and want to pay as little as possible and will settle for Good Enough™ security for your personal blog, you can always use the free tier of CloudFlare's SSL.


> **Caution:** CloudFlare SSL comes in [varying levels of security](https://support.cloudflare.com/hc/en-us/articles/200170416-What-do-the-SSL-options-mean-).  The two options that will work out of the box with PWS are the "Flexible" level and the "Full (non-strict)" level. The "Flexible" setting terminates the SSL connection at their CDN layer and carries out the rest of the request over regular HTTP between CloudFlare and the PWS servers. The "Full" setting uses HTTPS the whole way through, but won't attempt to validate any certificates between the CloudFlare servers and the PWS servers. For my blog, "Full" is good enough for a blog like mine, but if your static site's traffic needs to be truly secure, you may want to pay for the Pivotal SSL service or host your site elsewhere.

If you're fine with limitations of CloudFlare's SSL, just go ahead and sign up on [their site](https://www.cloudflare.com) and follow their [getting started docs](https://support.cloudflare.com/hc/en-us/articles/201720164-Step-2-Create-a-Cloudflare-account-and-add-a-website).

Once you've got your domain pointing to their nameservers, just add the same DNS settings that you configured earlier. It should look something like this:


<div>
	<img src="https://images.downey.io/blog/cloudflare-pws-dns.png">
</div>

There will be a warning regarding the non-subdomain form of the domain (e.g. `example.com`) being configured as a `CNAME`, but it should be fine. CloudFlare will "flatten" it into representing the IP that the target domain currently resolves to which should account for any changes behind the scenes with the `cfapps.io` domain on PWS.

Finally, to enable SSL, just go over to the "SSL" tab and switch it on to "Full." The process is similar to the process for [enabling CloudFlare SSL with Github Pages](https://blog.cloudflare.com/secure-and-fast-github-pages-with-cloudflare/) -- the main difference is just in the DNS settings we set up earlier.

## Wrapping It Up
Well, that's about it. At this point feel free to try this out with your static site for real and feel free to scale up or down the memory and instance counts as you see fit. I find in practice I can get away with 32M of memory (perhaps even less) for a simple Jekyll site and a single instance since the CloudFlare CDN is doing the brunt of the work.

Thanks for taking the time to read through all of this and good luck!
