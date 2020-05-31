---
layout: post
type: blog
title: "How to Add a Custom 404 Error Page to a Cloud Foundry Staticfile Buildpack Site"
sub_title:  "Replacing the Staticfile Buildpack's Default NGINX 404 Page"
color: badge-accent-3
icon: fa-code
date: 2017-09-22
last_modified_at: 2018-02-25
categories:
  - blogging
  - static site hosting
  - custom nginx 404 page
  - cloud foundry
  - staticfile buildpack
excerpt:
  "Although Cloud Foundry makes it simple to get your static site up and running on the web, getting rid of the default NGINX 404 page can be a bit tricky. This post will walk you through tweaking the Staticfile buildpack's NGINX config to serve custom error pages."
description:
  "How to specify a custom 404 Not Found error page for a static site deployed to Cloud Foundry using the Staticfile buildpack."
---

<div>
<img src="https://images.downey.io/blog/default-nginx-404-error-page.png" alt="Default NGINX 404 Page (in all of its glory)">
</div>

## important update
As of February 2018, the most recent version (`v1.4.22`) of the Staticfile buildpack has first-class support of custom error pages. You can now just enumerate various status codes and the page that you would like to display for them. Just add something like this to your `Staticfile`:

```yaml
status_codes:
  404: /path/to/404.html
  500: /path/to/500.html
```

For my site, my `Staticfile` now looks like this since my `404.html` page is at the top level of my `public` folder:

```yaml
root: public
status_codes:
  404: /404.html
```

The rest of the post still applies to older versions of the buildpack and still serves as an example of how to use the buildpack's `location_include` functionality.

## error 404 - configuration options not found

Earlier this week I wrote about [how to deploy a static site to Cloud Foundry]({{ site.baseurl }}{% post_url 2017-09-17-how-to-deploy-static-site-cloud-foundry %}), and once you've familiarized yourself with [the basic of Cloud Foundry](https://pivotal.io/platform/pcf-tutorials/getting-started-with-pivotal-cloud-foundry/introduction), it's pretty darn simple. However, as I migrated one of my sites over from GitLab pages over to Pivotal Web Services I did run into one issue that was particularly annoying: my site was using the default NGINX 404 page and not my lovingly crafted `public/404.html`.

Now I figured this would be a simple fix. After all, Github pages will serve up a `404.html` page automatically and even Amazon S3, despite its byzantine management console, makes it pretty intuitive to set up a "not found" document to serve. So I Googled.

And I didn't have a whole lot of luck. I did see that you could replace the `nginx.conf` that the Staticfile buildpack uses to deploy the NGINX server that serves up your static site, so I tried that. I used `cf ssh` to ssh on to my app and downloaded copied the existing config so that I could append an `error_page` declaration to it. This wasn't ideal.

1. This meant that I would no longer be able to automatically take advantage of improvements that the Staticfile buildpack might make to their `nginx.conf` in the future
1. It also meant I had to get a bit too familiar with NGINX config to do something that should have been simple

There had to be an easier way. So I [logged an issue](https://github.com/cloudfoundry/staticfile-buildpack/issues/116) to their project to request the ability to set a custom 404 page as a feature. They agreed that it might be valuable, but also let me know of a better way to do what I had already done.

## configuring a custom 404 page

Turns out that you can include a `location_include` directive in your `Staticfile` ([docs](https://docs.cloudfoundry.org/buildpacks/staticfile/index.html#config-process)). This is a powerful directive that will pull in files specified from your `nginx/conf` directory and include them in the generate `nginx.conf` file [here](https://github.com/cloudfoundry/staticfile-buildpack/blob/c88520c67ec01659751c88acafeee50e059d7852/src/staticfile/finalize/data.go#L121). So to get my site to serve my custom 404 page, I did the following:

1\. Added an `nginx/conf/includes` directory to the top-level of my project

2\. Added an `error404.conf` file to the `nginx/conf/includes` directory that contained the following config:

{% highlight nginx %}
error_page 404 /404.html;
location = /404.html {
  internal;
}
{% endhighlight %}

This tells NGINX to look for a `/404.html` page within its configured root (`_site` for my example Jekyll site) that is set by the buildpack at the top of the NGINX `location` block.

3\. Added the following directives to my `Staticfile`:
{% highlight yaml %}
root: _site
location_include: includes/*.conf
{% endhighlight %}

This config instructs the Staticfile buildpack to set the Jekyll-generated `_site` folder for the site as root and tells it to include every `.conf` file within the `nginx/conf/includes` directory that we created earlier. Make sure you include the `root` directive since the docs mention that the buildpack requires it be configured alongside `location_include` for it all to work properly.

After all that, just `cf push` up your changes and your site should now be serving your custom 404 page instead of that nasty NGINX default.

Again, you can check out [my example Jekyll site (tree #e895f96)](https://github.com/tcdowney/jekyll-cf-static-site-example/tree/e895f962017b9447899c21518fb018cf4eb1f126) to see a concrete example of how all of this looks in a real-ish codebase. You can also visit its deployed error page [here](https://jekyll.cfapps.io/i-dont-exist).

Hopefully this will all be made simpler in the future, but in the meantime, this has been the simplest way I've found to add a custom 404 page to a static Cloud Foundry site. Thanks for following along!
