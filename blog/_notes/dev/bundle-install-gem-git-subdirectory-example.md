---
layout: post
type: note
title: "Installing a Gem From a Git Repository Subdirectory using Bundler"
color: red-violet
icon: fa-code
date: 2018-03-29
categories:
  - programming
  - ruby
  - gem
  - bundler
description:
  "How to bundle install a gem from a Git repository that is nested deep within the repository's root directory"
---
Sometimes projects, such as the [Cloud Foundry Copilot service](https://github.com/cloudfoundry/copilot/) include their Ruby client gems within [subdirectories](https://github.com/cloudfoundry/copilot/tree/feb69363fff010ea48e1dacd38ca859528cfa0d4/sdk/ruby) of the main project itself. While under active development, it can be useful to install the gem directly from the Git repository. Bundler [makes this pretty easy](http://bundler.io/guides/git.html) for gems that have standalone repos, but there is no clear way to include a gem that is nested deep within a repo. Fortunately, the poorly documented `glob` parameter can help. 😊

For example, the `cf-copilot` gem above can be included in a `Gemfile` like this:
```ruby
# Gemfile
gem 'cf-copilot', git: 'https://github.com/cloudfoundry/copilot.git', branch: 'master', glob: 'sdk/ruby/*.gemspec'
```

Just give it a `glob` path to the gem's `.gemspec` file that is relative to the repository's root and `bundler` will handle the rest!
