---
layout: post
title: "Testing i18n in Ruby on Rails"
sub_title:  "Rooting Out Missing Translations"
color: red
icon: fa-code
date: 2014-10-09
categories:
  - programming
  - i18n
  - rails
  - ruby
  - l10n
  - internationalization
excerpt:
  "Verifying that all user-facing copy in your Rails application is localized can be a challenge.  While manual validation may work for smaller sites, for larger, more complex applications it can be practically a fool’s errand.  If your situation happens to sound more like the latter, don’t lose hope!  In this post I am going to cover a few of the methods to easily and automatically test your Rails app for missing translations."
description:
  "Techniques and advice for testing internationalization (i18n) and localization (l10n) in your Ruby on Rails application."
---
Verifying that all user-facing copy in your Rails application is localized can be a challenge.  While manual validation may work for smaller sites, for larger, more complex applications it can be practically a fool’s errand.  If your situation happens to sound more like the latter, don’t lose hope!  In this post I am going to cover a few of the methods to easily and automatically test your Rails app for missing translations.

## Fail Early
If you’re using Rails 4.1.0 or above I recommend adding some basic config to your `test.rb` and `development.rb` Rails environments.

{% highlight ruby %}
# config/environments/test.rb
# config/environments/development.rb
Rails.application.configure do |config|
  config.action_view.raise_on_missing_translations = true
end
{% endhighlight %}

This config will make the  `t()` translation helper raise an exception on encountering a missing translation rather than falling back to its default behavior.

This can be especially helpful for those cases where it may not be so obvious that you have a missing translation.  For example, even if `t(‘.hello’)` appears to be translated, it may actually be outputting `<span class=”translation_missing”>Hello</span>`.  Though this missing translation would be hidden from your English speaking users, that won’t be the case for everyone else.  For this reason I prefer for my  translation and localization helpers to fail early and fail loudly.

For information regarding raising exceptions on missing translations in past versions of Rails, I recommend reading Thoughtbot's post on [Foolproof I18n Setup in Rails](http://robots.thoughtbot.com/foolproof-i18n-setup-in-rails).

## perform static code analysis
The next line of defense in our war on missing translations is through the usage of a static i18n analysis tool such as the [i18n-tasks gem](https://github.com/glebm/i18n-tasks).  Although i18n-tasks has many great features, the one that I have found most valuable is its ability to find missing translations in both Ruby and Javascript code (assuming you’re using `i18n-js`) across all of your locale files.  The beauty of static code analysis is that it will cover all of your code even if you may not quite have 100% test coverage.

To start using the i18n-tasks gem, just follow the [installation instructions](https://github.com/glebm/i18n-tasks#installation) in the gem’s README.

In order to avoid false positives, you may need to add a few lines of additional configuration to the `i18n-tasks.yml` file.  For example, if you’re invoking the translation helper from any non-view files (eg. presenters, helpers, etc.) and relying on relative roots (like ‘.help’), it’s important that you add these root paths to your `i18n-tasks.yml` file.

Additionally, if you’re relying on any gems that include their own locale files, you will want to add these to the search paths in your config as well.

{% highlight yml %}
# i18n-tasks.yml
# ...other config...
data:
  read:
    - "<%= %x[bundle show gem_name].chomp %>/config/locales/%{locale}.yml"
    - config/locales/%{locale}.yml
# ...other config...
search:
  relative_roots:
    - app/views
    - app/presenters
    - app/helpers
# ...other config...
{% endhighlight %}

Feel free to use ERB in the `i18n-tasks.yml` file since the gem will automatically [parse it with Erubis](https://github.com/glebm/i18n-tasks/blob/master/lib/i18n/tasks/configuration.rb#L16) before loading the YAML config.

One caveat to i18n-tasks (and static code analysis in general) is that it won’t work well for dynamically generated code.  For our purposes, that means that the gem will fail to detect missing translations resulting from dynamic translation keys (ie. `t(“errors.#{ error_name }.description”)`).  Now although I understand the appeal of dynamic translation keys, I advise being explicit with your translation keys.  Just skip the interpolation altogether and use a case statement to select the correct key.  Sure your codebase will be a few lines longer and your code will be slightly more verbose, but you’ll help mitigate the risk of having one of you users encounter a missing translation in production.

## write automated feature specs
You may find it valuable to have some automated feature specs hitting your application in all of your supported locales using [RSpec](https://github.com/rspec/rspec), [Capybara](https://github.com/jnicklas/capybara), and [capybara-webkit](https://github.com/thoughtbot/capybara-webkit) (this is a WebKit driver for Capybara that will allow your feature specs to execute your application’s Javascript code).

Keep in mind that a comprehensive suite of feature specs will be expensive both in terms of developer time and execution time, so it really is a judgement call as to whether or not they’ll provide enough value to your project to justify the expense.  However, if you do decide to write some, remember that they will likely be slow so I recommend reserving them for your Jenkins/Travis CI builds or whatever form of continuous integration you use.

For those of you still using RSpec 2.x, I recommend following the setup instructions on [this](http://blog.55minutes.com/2013/10/test-javascript-with-capybara-webkit/) blog post.  If you’ve been proactive and upgraded to RSpec 3.x, I still recommend following those instructions, but just know that you’ll have to make a few minor tweaks to get it working correctly.  Just follow an [RSpec 3 upgrade guide](https://relishapp.com/rspec/docs/upgrade) and the process shouldn't be too painful.  Also, just as a heads up, the code samples that follow were written using `rspec 3.1.0`, `capybara 2.4.3`, and `capybara-webkit 1.3.0`.

Once you’ve got everything set up, there are several ways to go about finding missing translations in your application.  First, especially for your most critical content, you may want to explicitly test that it is translated.  For example, say you want to test that your site is displaying the appropriate welcome message on its home page based on the language settings of your user's browser.  Here is one way of doing that:

{% highlight ruby %}
# spec/features/home_page_spec.rb
require 'rails_helper'

RSpec.describe 'user views home page', :type => :feature do  
  # Configure capybare to set the 'Accept-Language' header to the appropriate locale
  # and set the locale that is used for the expected result comparison.
  before do
    page.driver.header 'Accept-Language', locale
    I18n.locale = locale
  end

  context 'when the user has set their locale to :en' do
    let(:locale) { :en }

    it 'displays a translated welcome message to the user', :js => true do
      visit(root_path)
      expect(page).to have_content I18n.t('home.index.welcome')
    end
  end

  context 'when the user has set their locale to :zh' do
    let(:locale) { :zh }

    it 'displays a translated welcome message to the user', :js => true do
      visit(root_path)
      expect(page).to have_content I18n.t('home.index.welcome')
    end
  end
end
{% endhighlight %}

If you are less concerned about specific translations and just want to be alerted of missing translations in general, then I suggest just using Capybara to check the page body for the indicators that the translation libraries attach such as `translation_missing` class that’s inserted by the regular Rails `t()` helper or the `[missing “en.whatever” translation]` text that i18n-js inserts.  One way of doing this is by writing a custom RSpec Matcher:

{% highlight ruby %}
# spec/support/missing_translations.rb
require 'rspec/expectations'

RSpec::Matchers.define :have_missing_translations do
  match do |actual|
    missing_i18n_js = /\[missing ".*" translation\]/
    missing_i18n_ruby = /class="translation_missing"/
    !!(actual.body.match(missing_i18n_ruby) || actual.body.match(missing_i18n_js))
  end

  failure_message_for_should do |actual|
    'expected page to have missing translations'
  end

  failure_message_for_should_not do |actual|
    'expected page to not have missing translations'
  end
end
{% endhighlight %}

Simply `require 'support/missing_translations' in your `spec_helper.rb` file and you’re ready to use it throughout your specs.

{% highlight ruby %}
# spec/features/home_page_spec.rb
require 'rails_helper'

RSpec.describe 'user views home page', :type => :feature do  
  # Configure capybare to set the 'Accept-Language' header to the appropriate locale
  # and set the locale that is used for the expected result comparison.
  before do
    page.driver.header 'Accept-Language', locale
    I18n.locale = locale
  end

  context 'when the user has set their locale to :en' do
    let(:locale) { :en }

    it 'should not have missing translations', :js => true do
      visit(root_path)
      expect(page).not_to have_missing_translations
    end
  end

  context 'when the user has set their locale to :zh' do
    let(:locale) { :zh }

    it 'should not have missing translations', :js => true do
      visit(root_path)
      expect(page).not_to have_missing_translations
    end
  end
end
{% endhighlight %}

Well that just about wraps it up.  Like I said earlier, testing that everything in your app is properly localized is hard.  The techniques above can make it just a little bit easier, though.  I'd like to finish this post with some links to addition i18n resources that you may find helpful. :)

## Additional i18n Resources
* [i18n on Rails: A Twitter Approach](http://www.youtube.com/watch?v=CTu4iHWGDyE)
* [Twitter CLDR](https://blog.twitter.com/2012/twittercldr-improving-internationalization-support-in-ruby)
* [W3C Internationalization Article List](http://www.w3.org/International/articlelist)
