---
layout: post
type: blog
title: "Batch Uploading Photos to Amazon S3 with Mitty"
sub_title:  "Using Mitty for Jekyll Photo Blogs"
color: teal
icon: fa-camera-retro
date: 2015-09-12
categories:
  - photography
  - images
  - amazon s3
  - mitty
  - ruby gems
excerpt:
  "I've had my Jekyll-powered static photo blog for a little over a year now and I really appreciate the control it gives me over my photographs.  What I didn't enjoy so much, however, was resizing them and uploading them to one of my AWS S3 buckets for hosting to display them on the blog.  That's where mitty comes in."
description:
  "How I use my gem, Mitty, to batch process and upload images to an Amazon S3 bucket for use on my Jekyll-powered photo blog."
---
I've had my [Jekyll-powered static photo blog](http://photo.downey.io/) for a little over a year now and I really appreciate the control it gives me over my photographs.  What I didn't enjoy so much, however, was resizing them and uploading them to one of my AWS S3 buckets for hosting to display them on the blog.  That's where [mitty](https://github.com/tcdowney/mitty) comes in.  Around a month ago I decided to create a Ruby gem that would automate this process with minimal configuration.  After I do the brunt of my photo editing in Adobe Lightroom and export full quality JPEGs, I can simply run the `mitty manage` command to automatically generate thumbnails, create both low and high quality versions of the images in different sizes, and the upload them all to an AWS S3 bucket for storage and hosting.

## Prerequisites
* Linux or Mac OS X
* Amazon Web Services account
* Ruby 2.1+

The `mitty` gem relies on [rmagick](https://github.com/rmagick/rmagick) for photo manipulation, which means it will need to install ImageMagick on your system.  That's easy enough on Linux or OS X, but I know it can be finicky on Windows.  Given that, I haven't tested it on Windows at all, so chances are it will not work out of the box.

## Installation

To install the gem, just follow the instructions in the [README](https://github.com/tcdowney/mitty#installation).  It will cover the gem installation itself, as well as what configuration options are available/required.

In order to upload images to an Amazon S3 bucket, mitty requires a valid `aws_access_key_id` and `aws_secret_access_key`.  Although I allow this to be configured via the `.mitty` file, I recommend storing these values in environment variables so that they aren't accidentally checked in to source control or otherwise leaked.  I also recommend creating an AWS that has minimal access.  It should only need to have permissions to a single bucket.  For more information acquiring these keys and best practices in general, I recommend reading the [Managing AWS Access Keys documentation](http://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html).

## Batch Resizing Images with Mitty
At the time of writing this post, `mitty` currently only works with `.jpg` format images.  There are no technical reasons why it shouldn't be able to support other image types, like PNG, I just haven't gotten around to it yet. :)

Right now the gem is capable of creating cropped square thumbnails of images, resizing images while maintaing aspect rations, and generating both low quality and high quality versions of images.  This process can be executed in isolation by running the following command (if you ever need a refresher on what options are available for any command, simply execute `mitty help` for an explanation):

{% highlight bash %}
mitty resize PATH
{% endhighlight %}

By default, this will generate thumbnails as well as small, medium, and large versions of your images.  If the `generate_low_quality` configuration value is set to `true`, it will also generate both low and high quality versions of your images in every size.

As an aside, several folks have asked me what is the purpose of generating low quality versions of images.  Well, in short, it is to help improve page load times.  I've found that having several high quality images on a page at once resulted in unacceptable load times, particularly on mobile.  A solution I found was to initially load low quality versions of images on the page and then use [lazysizes.js](https://github.com/aFarkas/lazysizes) to load the nicer looking images after the page has loaded.

## Batch Uploading Images to AWS with Mitty
Images can be uploaded to an Amazon S3 bucket in isolation without any additional processing via the following command:

{% highlight bash %}
mitty upload PATH
{% endhighlight %}

As I mentioned earlier, the upload command can accept AWS access key IDs and secret access keys in several ways.  By default, it will look in the `.mitty` configuration file.  If `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables are set, it will use those instead.  Lastly `--access_key_id` and `--secret_access_key` command line options can be provided to the `mitty upload` command.  These take highest precedence.  Of the three, I recommend the environment variables.

By default, the upload command will upload the images to a folder named for the current date.  However, the name of this folder can be overwritten with the `--object_key_prefix` option.  Likewise, by default it will upload images to the bucket specified in the `.mitty` configuration file, but this too can be overwritten with the `--bucket` option.  You can even set the [ACL permissions](http://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#setting-acls) of the images with the `--acl` option.  I know all of that can be confusing so here's an example:

{% highlight bash %}
mitty upload PATH --access_key_id SOME_AWS_ACCESS_KEY_ID \
                  --secret_access_key SOME_AWS_SECRET_ACCESS_KEY \
                  --object_key_prefix photos \
                  --bucket image-bucket \
                  --acl private
{% endhighlight %}

The above command will use "SOME_AWS_ACCESS_KEY_ID" and "SOME_AWS_SECRET_ACCESS_KEY" as the AWS Access Key ID and Secret Access Key to authenticate with Amazon Web Services.  It will then upload the images to an AWS S3 bucket named "image-bucket" and place them in a folder called "photos".  Lastly, these images will use the "private" ACL so only owners of the bucket can view or edit them.

## Mitty Manage
The `resize` and `upload` commands can help save a lot of time, but they are still pretty fine-grained.  I wanted a command to automate my entire workflow.  This is where the `mitty manage` command comes in.

{% highlight bash %}
mitty manage PATH
{% endhighlight %}

Running the `manage` command will create thumbnails and all sizes of the images and then directly upload them to Amazon S3 using the current date as the object key prefix.  It will also copy the original images on over for safe keeping (these are managed by a second ACL configuration value).

This command is pretty tailored to my own personal workflow, but I think others could find it useful as well.  If not, feel free to fork it and modify it!
