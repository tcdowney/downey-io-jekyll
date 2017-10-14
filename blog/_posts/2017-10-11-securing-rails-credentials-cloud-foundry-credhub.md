---
layout: post

type: blog
title: "Securing Rails Secrets with Cloud Foundry CredHub"
sub_title:  "Credgazing with CredHubble 🔭"
color: red-violet
icon: fa-key
date: 2017-10-11
categories:
  - rails secrets
  - cloud foundry
  - ruby credhub client
  - credhub
  - ruby gems
excerpt:
  "Over the years, secret management in Rails has greatly improved. Gone are the days of the version-controlled secret_token.rb and now providing secrets through environment variables is encouraged. Environment variables can come with their own problems, however. Luckily with Cloud Foundry and CredHub, there's another way."
description:
  "Using Cloud Foundry CredHub to store Rails credentials and other secrets."
---

<div>
<img src="https://s3.amazonaws.com/images.downey.io/blog/credhubble-credgazing.jpg" alt="Gazing at all the CredHub credentials in the Milky Way">
</div>

## Storing Rails Secrets

Rails apps these days come with a [secrets.yml](http://guides.rubyonrails.org/4_1_release_notes.html#config-secrets-yml) file which conveniently populates a `Rails.application.secrets` object which can be accessed throughout the application.
While you could just fill this file up with all of your sensitive credentials and check it into a private repo, that's probably not the best idea -- and I doubt most of you are doing that.
Instead, you're probably either generating it at deployment time with a tool like Chef, or taking the [Twelve-Factor App](https://12factor.net/config) approach and supplying your secrets at runtime through environment variables.

Don't get me wrong, both of these approaches are far superior to just hoping your `secrets.yml` doesn't get leaked, but they still pose some risk.
For example, even if you're storing your cred in encrypted databags on your Chef server, what happens if the populated file on disk gets leaked? Similarly, environment variables [have their own problems](https://news.ycombinator.com/item?id=8826024).

Luckily, for Rails apps deployed to Cloud Foundry with a [CredHub](https://docs.cloudfoundry.org/credhub/), there's another way.

At it's most basic, CredHub is just an encrypted credential store -- similar to [HashiCorp Vault](https://www.hashicorp.com/blog/Vault-announcement/).
What makes CredHub nice, though, is how seamlessly your Cloud Foundry deployed apps are able to communicate with it.

## Introducing CredHubble -- A CredHub Ruby Client
So how do you integrate CredHub with your Rails app? This is where the [CredHubble CredHub ruby client](https://github.com/tcdowney/cred_hubble) comes in. CredHubble is an http client for the CredHub API that I've been working on in my spare time since there's currently no official Ruby client available. I used to make service clients all of the time while working on [HealtheIntent at Cerner](http://www.cerner.com/page.aspx?pageid=17179876814) so it was a bit nostalgic to get to play around with [Faraday](https://github.com/lostisland/faraday) and [Virtus](https://github.com/solnic/virtus) again.

It's not an unofficial client, so I didn't want to take an official sounding name `credhub-ruby` or something. So I thought real hard and tried to be creative.

CredHubble was the best I could come up with. It lets you look at or view credentials, just like the Hubble Space Telescope lets you look at much cooler things. Like galaxies and supernovas. Yeah...

CredHubble is not perfect by any means and CredHub has a pretty simple API so you could whip up something custom with `Net::Http` pretty quickly and name it something even better if you want. 😉

It does handle most of the [CredHub API endpoints](https://credhub-api.cfapps.io/) that you're most likely to care about as an app developer, though.

Anyways, here's how you can use CredHubble to fetch secrets from CredHub and populate your `secrets.yml`.

First, add `cred_hubble` to your Gemfile and run `bundle install`. This will install the gem and make it available to your app.

{% highlight ruby %}
gem 'cred_hubble', '~> 0.1.0'
{% endhighlight %}

Next, we're going to make an initializer to bootstrap the client.

## Initial Client Setup

If your environment has a CredHub instance deployed, your app instances will automatically come with two environment variables:

* `CF_INSTANCE_CERT`
* `CF_INSTANCE_KEY`

These point to a TLS client certificate and TLS encryption key that your app can use to authenticate with CredHub over mutual TLS. The CredHub servers's TLS cert's CA will already be included among the Diego cell's trusted certificate authorities so you don't need to worry about it.
We'll use these two variables to instantiate our client:

{% highlight ruby %}
# initializers/credhub.rb

# Example environment variable values:
# ENV['CREDHUB_API'] = 'credhub.example.com'
# ENV['CREDHUB_PORT'] = 8844
# ENV['CF_INSTANCE_CERT'] = '/etc/cf-instance-credentials/instance.crt'
# ENV['CF_INSTANCE_KEY'] = '/etc/cf-instance-credentials/instance.key'
class Credhub
  def self.client
    @client ||= CredHubble::Client.new_from_mtls_auth(
      host: ENV['CREDHUB_API'],
      port: ENV['CREDHUB_PORT'],
      client_cert_path: ENV['CF_INSTANCE_CERT'],
      client_key_path: ENV['CF_INSTANCE_KEY']
    )
  end
end
{% endhighlight %}

## Using your CredHub Client

Now that you have a client available throughout your app, you can call out to it in your `secrets.yml`. Here's a brief example of what that might look like:


{% highlight yaml %}
# config/secrets.yml

# Example environment variable values:
# ENV['CH_SECRET_KEY_BASE'] = '/secret-key-base'
# ENV['CH_ACCESS_KEY_ID'] = '/aws-access-key-id'
# ENV['CH_SECRET_ACCESS_KEY'] = '/aws-secret-access-key'
# ENV['VCAP_SERVICES'] = '{"credentials": {"credhub-ref": "/some-other-secrets"}'
production:
  secret_key_base: <%= Credhub.client.current_credential_value(ENV['CH_SECRET_KEY_BASE']) %>
  aws_access_key: <%= Credhub.client.current_credential_value(ENV['CH_ACCESS_KEY_ID']) %>
  aws_secret_access_key: <%= Credhub.client.current_credential_value(ENV['CH_SECRET_ACCESS_KEY']) %>
  vcap_services: <%= Credhub.client.interpolate_credentials(ENV['VCAP_SERVICES']) %>
{% endhighlight %}

In the above example, the CredHub credential names are passed in through environment variables for deployment convenience.
This allows them to be set with a simple `cf set-env` or specified in your application's CF `manifest.yml`.

So what's going on here? Well it's really pretty simple. The `current_credential_value` method on the Credhub client fetches the current value for the credential with the given name (e.g. `'/secret-key-base'`).
CredHub saves historical versions of credentials for auditing and to simplify credential rotation, but for our example app we only care about the most up to date version.

The `interpolate_credentials` method takes in a JSON encoded string, such as the [VCAP_SERVICES environment variable](https://docs.run.pivotal.io/devguide/deploy-apps/environment-variable.html#VCAP-SERVICES) and will ask CredHub to populate any credentials that have `"credhub-ref"` as their key.
This is handy for getting access to any service instance credentials that may have been stored in CredHub*.

\* **Note:** Future versions of Cloud Foundry will support dereferencing `VCAP_SERVICES` automatically and will populate you app's environment with the dereferenced values so that applications do not need to be CredHub-aware.
This can behavior can be disabled, however, so you still may need to have your app "interpolate" `VCAP_SERVICES` manually.

## Getting Credentials into CredHub

We've now seen how to read secrets from CredHub and place them directly into our `secrets.yml` file. But how do we get them up there in the first place?

The CredHubble client supports setting credentials, but you may also find it easier to just use the [credhub-cli](https://github.com/cloudfoundry-incubator/credhub-cli) and to [follow the docs](https://credhub-api.cfapps.io/#set-credentials).
It's important to note, though, if you're using the CLI with UAA auth, the important thing here is to give your app the appropriate permissions to be able to read any Credentials you've made. This means give `"read"` permissions to the `"mtls-app:<app-guid>` actor.

Anyways, here's how you can do it with CredHubble from within a Rails Console:

Instantiate the client (or just use the Credhub.client we made in our initializer):
{% highlight ruby %}
credhub_client = CredHubble::Client.new_from_mtls_auth(
  host: ENV['CREDHUB_API'],
  port: ENV['CREDHUB_PORT'],
  client_cert_path: ENV['CF_INSTANCE_CERT'],
  client_key_path: ENV['CF_INSTANCE_KEY']
)
{% endhighlight %}

Create your credential:
{% highlight ruby %}
credential = CredHubble::Resources::ValueCredential.new(
  name: '/my-test-credential',
  value: 'super-secret'
)
{% endhighlight %}

Set your credential:
{% highlight ruby %}
credhub_client.put_credential(credential)
{% endhighlight %}

You can now retrieve it and view its permissions:
{% highlight ruby %}
> credhub_client.current_credential_value('/my-test-credential')
    => "super-secret"
> credhub_client.permissions_by_credential_name('/my-test-credential').first.actor
    => "mtls-app:b8a27cbf-1fc3-40d4-a381-7f4566d03710"
> credhub_client.permissions_by_credential_name('/my-test-credential').first.operations
    => ["read", "write", "delete", "read_acl", "write_acl"]
{% endhighlight %}

Well there you have it, a way to make your Cloud Foundry deployed Rails app a bit more secure through CredHub and CredHubble.
I hope you found this post helpful, and if not... well at least I tried. 🔭🌝
