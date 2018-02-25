---
layout: post
type: blog
title: "How to Add Custom Language Files to CKEditor 4"
sub_title:  "Localizing CKEditor Without Requiring a Custom Build"
color: red-violet
icon: fa-code
date: 2015-12-30
categories:
  - localization
  - internationalization
  - ckeditor
  - ckeditor rails
  - ckeditor cdn
excerpt:
  "Although CKEditor 4 ships with support for over 60 different language variants, you may find yourself needing to add a 61st.  Or maybe while localizing your application you've found that you need to tweak the phrasing for an existing locale.  Here's how to add support for new languages to CKEditor and modify existing translations without needing to generate a custom build."
description:
  "How to add support for new languages to CKEditor 4 and change existing translations without generating a custom build."
---

<div><img src="https://s3.amazonaws.com/stuff.downey.io/images/localized-ckeditor.png" alt="Localized CKEditor Displaying Japanese Kanji"></div>

Thanks to its active community, CKEditor 4 has already been translated into over 60 languages and is displayed in its user's language by default ([more information](http://docs.ckeditor.com/#!/guide/dev_uilanguage)).  If you have a small project or you don't need to worry about supporting any additional languages, then great, you can stop right here.  However, if you need to support additional languages or need to customize the content of an included language, you have one of three options:

1. Contribute to CKEditor's [Transifex project](https://www.transifex.com/ckeditor/ckeditor/)
2. Create a [custom build of CKEditor](http://ckeditor.com/builder) and edit the language source files ( located in `ckeditor/lang`)
3. Replace the existing language data with your own at run time

If you have the time and resources, go with the first option if at all possible.  By giving back to the community and contributing translations, others won't have to go through the pain you went through. :)

Not everyone has the luxury of being able to contribute, however. For example, you may need to modify an existing language to better serve your users needs. Or maybe you need to add support for a new language immediately and you simply can't wait around for your contributions to reach the CKEditor trunk.

If you are able to use a custom build of CKEditor, definitely go with option two.  There are a number of benefits to using a custom build (smaller footprint, more streamlined editor, etc.) and editing / adding language files will be much simpler.  To edit an existing language, just navigate to the `ckeditor/lang` directory within the project and edit the files directly.  To add a new language, just mirror the structure of an existing language file and add your new locale to CKEditor's `CKEDITOR.lang.languages` object so that the editor is aware of its existence:

{% highlight js %}
CKEDITOR.lang.languages['my-new-language'] = 1;
{% endhighlight %}

But what if you can't access the CKEditor source?  For example, you are loading CKEditor from a [CDN](https://cdn.ckeditor.com/) or you are including it in a Ruby on Rails application by using a gem such as [ckeditor-rails](https://github.com/tsechingho/ckeditor-rails).  What then?

Let's say we have a Rails app and we're including CKEditor using the `ckeditor-rails` gem.  First find out what your language files look like by inspecting the [source code of ckeditor-rails](https://github.com/tsechingho/ckeditor-rails/blob/master/vendor/assets/javascripts/ckeditor/lang/en.js) of one of the language files that you can understand.  You will then build off of this file to either modify the data for an existing language or create add a new one altogether.  The process for both editing/adding is very similar, the only difference is that to add a new language you will have to make CKEditor aware of it as we mentioned above.

Anyways, chances are you'll already have an `app/assets/javascripts/ckeditor` directory where you're keeping your `config.js` file that you've been using to customize your editor.  I recommend adding the additional languages that you'll be supporting to the `CKEDITOR.lang.languages` object in this file to help keep all of your custom CKEditor configuration consolidated.  Here we'll add our custom dialect of English:

{% highlight js %}
// app/assets/javascripts/ckeditor/config.js

CKEDITOR.lang.languages['en-US-CUSTOM'] = 1;
{% endhighlight %}

Now, create a `lang` directory within your `app/assets/javascripts/ckeditor` directory and add your `en-US-CUSTOM` language file.  Here's a contrived example of what that file may look like:

{% highlight js %}
// app/assets/javascripts/ckeditor/lang/en-US-CUSTOM.js

CKEDITOR.lang['en-US-CUSTOM'] = {
  "editor": "My Custöm Editor!",
  "save": "Pls save",
  "undo": {
    "redo": "Put it back!",
    "undo": "Oops"
  }
};
{% endhighlight %}

Now just make sure this `lang` directory is required in your `application.js` [manifest file](http://guides.rubyonrails.org/asset_pipeline.html#manifest-files-and-directives) and voilà, you've added support for a new language to your CKEditor implementation!

If you're not using Rails, the process will still be more or less the same, just make sure that your new languages are loaded on the page before you initialize the editor.  Here is an example of what that could look like:

{% highlight html %}
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>My Localized CKEditor</title>
    <script src="https://cdn.ckeditor.com/4.5.6/basic/ckeditor.js"></script>
    <script src="https://assets.example.com/ckeditor/config.js"></script>
    <script src="https://assets.example.com/ckeditor/lang/en-US-CUSTOM.js"></script>
  </head>

  <body>
    <form>
      <textarea name="localized-editor"></textarea>
    </form>
    <script>
        CKEDITOR.replace('localized-editor');
    </script>
  </body>
</html>
{% endhighlight %}

Well there you have it, a means of adding custom locales to CKEditor and new languages files without needing to create a custom build of the editor.
