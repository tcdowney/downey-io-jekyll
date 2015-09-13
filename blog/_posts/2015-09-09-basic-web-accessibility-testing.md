---
layout: post
type: blog
title: "Web Accessibility Testing for Everyone"
sub_title:  "Simple Ways to Evaluate Your Site"
color: violet
icon: fa-wheelchair
date: 2015-09-09
categories:
  - programming
  - web applications
  - accessibility
  - user experience
excerpt:
  "Accessibility is a topic that many developers seldom have to think about. Sure most of us are aware that having an accessible website is a good thing to have, but when it comes time to code it is often not in the forefront of our minds.  We're generally more focused on adding new features or tweaking visual designs.  But just how valuable can these improvements truly be if a percentage of our users cannot even interact with them?"
description:
  "An introduction into the basics of web application accessibility. Simple steps that web developers can take to make sites more accessible."
---
Accessibility is a topic that many developers seldom have to think about. Sure most of us are aware that having an accessible website is a good thing to have, but when it comes time to code it is often not in the forefront of our minds.  We're generally more focused on adding new features or tweaking visual designs.  But just how valuable can these improvements truly be if a percentage of our users cannot even interact with them?

Now I'm not saying you have to shoot for full [Section 508 compliance](http://www.section508.gov/) (although that would be nice), I'm simply advocating awareness and I would encourage all web developers to employ some of the following techniques for basic accessibility testing.

## Use an Accessibility Checklist
The WebAIM accessibility organization has published an unofficial [checklist](http://webaim.org/standards/508/checklist) to aid in adoption of the Section 508 web standards. A checklist helps make dense standards easier to digest and can help remove a lot of the guesswork involved in accessibility testing.  It will also help highlight important areas of accessibility that you may have not even considered, such as screen flickering rates, for example.

Alternatively, another [checklist](http://www.hhs.gov/web/section-508/making-files-accessible/checklist/html/index.html) is available from the U.S. Department of Health and Human Services.  It covers a lot of the same criteria as the WebAIM checklist, but I personally think it is a little less clear in regards to what exactly constitutes a "pass" and what is a "failure."

## Use Automated Accessibility Analysis Tools
Another avenue of testing that I'm fond of is the usage of automated tools, like the WebAIM organization's [WAVE tool](http://wave.webaim.org/).  WAVE, or the web accessibility evaluation tool, lets you input any web address and it will run a suite of tests against the site.

In addition to the typical color contrast checks, the WAVE tool will also point on places where supporting text is needed, such as missing `alt` attributes on images or `aria-label` attributes on icons.

## Simulate Alternative User Experiences
So you've gone through the checklists and put your site through the automated tooling gauntlet, what else is there to do?  Well one thing I've found helpful is to try and simulate how a user would interact with my sites non-visually.  To do so, I recommend installing the [NVDA screen reader](http://www.nvaccess.org/).  The NVDA (NonVisual Desktop Access) screen reader is an open source alternative to expensive paid options like [JAWS](http://www.freedomscientific.com/Products/Blindness/JAWS).  Once NVDA is installed and running, navigate to your site and unplug your mouse (or disable your trackpad).  Now it is time to use [keyboard navigation](http://www.ssa.gov/accessibility/keyboard_nav.html) and page through your site, using NVDA to provide audio queues.

It can be a slow and frustrating process, but in my opinion this is truly the best way to get a feel for how accessible your website or application actually is for the visually impaired.

Additionally, it can also be valuable to test how functional your application is for individuals with color blindness.  As the aforementioned checklists are quick to point out, any place where colors hold meaning will be a problem area.  As a non-visually impaired person, however, it can be sort of difficult to determine where problem areas actually are.  Tools like the [Color Oracle](http://colororacle.org/index.html) can help, however.  Color Oracle runs on Java and is available for Mac, Linux, and Windows and will allow you to simulate common forms of color blindness.  Since it is a desktop application, it's not restricted to the web either, so it can be handy for other types of applications as well.

## Additional Web Accessibility Resources
The tools and techniques mentioned above are really just the tip of the iceberg when it comes to evaluating the accessibility of a web site.  They won't get you all of the way to a compliant site, but it's definitely a start.  Feel free to visit the following links for more information on web accessibility standards:

* [WebAIM Organization](http://webaim.org/)
* [U.S. General Services Administration Section 508 standards](http://www.section508.gov/)
* [Web Content Accessibility Guidelines](http://www.w3.org/WAI/GL/)