---
layout: post
type: blog
title: "How to Write Custom Rubocop Linters for Database Migrations"
sub_title:  "Linting Migration Files With Your Very Own Rubocop Cops"
color: badge-accent-5
icon: fa-code
date: 2017-12-09
categories:
  - ruby
  - ruby on rails
  - active record migrations
  - sequel migrations
  - rubocop
excerpt:
  "Active Record and Sequel migrations provide an easy way for Ruby developers to alter their database schemas without having to write SQL by hand. This abstraction means that the same migration file could work against both a Postgres and MySQL database by simply changing the underlying database adapter. For large projects with many developers, however, it can be difficult to keep migration style consistent and enforce best practices without additional tooling. In this post we'll write our own custom Rubocop cop for linting migration files."
description:
  "How to write custom Rubocop linters for your Sequel and Active Record migrations."
---

[Active Record](http://edgeguides.rubyonrails.org/active_record_migrations.html) and [Sequel](http://sequel.jeremyevans.net/) migrations provide an easy way for Ruby developers to alter their database schemas without having to write SQL by hand. This abstraction means that the same migration file could work against both a Postgres and MySQL database by simply changing the underlying database adapter. For large projects with many developers, however, it can be difficult to keep migration style consistent and enforce best practices  without additional tooling.

As an example, the [Cloud Foundry](https://www.cloudfoundry.org/) [Cloud Controller](https://github.com/cloudfoundry/cloud_controller_ng) service uses the Ruby [Sequel gem](https://github.com/jeremyevans/sequel) as its ORM and can be run on both Postgres and MySQL-compatible databases. This flexibility means we need to take some special care when writing our migration files. Consider the following Sequel migration:

{% highlight ruby %}
Sequel.migration do
  change do
    create_table(:strings) do
      String :my_string
    end
  end
end
{% endhighlight %}


It's simple enough. As you might have guessed, this migration will create a new table called `strings` that has a single "String" column named `my_string`.
But what type of column actually is "String"? Well it depends on the database you're targeting! Since we didn't specify a limit in MySQL Sequel will create a `varchar(255)` that will hold 255 characters and in Postgres you'll get a `text` column that will hold an "unlimited" number of characters.

This discrepancy can be difficult to reason about throughout the rest of the codebase, so we'd prefer it if they were both consistent. In Sequel this is as simple as providing the `size` argument when creating the column:

{% highlight ruby %}
Sequel.migration do
  change do
    create_table(:strings) do
      String :my_string, size: 255
    end
  end
end
{% endhighlight %}

As a developer, this requirement can be easy to overlook when you're focused on developing a new feature and it also might not necessarily be caught in code review. This is where Rubocop comes in.

## What is Rubocop

If you've been developing in Ruby for some time, chances are you've used or at least heard of [Rubocop](https://github.com/bbatsov/rubocop). If not, Rubocop is a code linter that trawls through your code files using [static code analysis](https://en.wikipedia.org/wiki/Static_program_analysis) and finds problems, such as methods with too many lines, code style violations, or common gotchas.

Rubocop itself is just a gem that you can include as a development dependency in your project and it provides a handy `rubocop` cli and several rake tasks which you can either run manually or as part of your CI test suites. It even supports an `--auto-correct` option that can [automatically correct](https://github.com/bbatsov/rubocop/wiki/Automatic-Corrections) certain issues. It's pretty handy. 🙂

## Writing our own Rubocop Cop

> * **Note:** Unfortunately the methods available within Rubocop for developing your own cops aren't very discoverable. My general technique is to try to find an official cop in the [Rubocop codebase](https://github.com/bbatsov/rubocop/tree/master/lib/rubocop/cop) that vaguely matches what I'm trying to do and reverse engineer it. They do have a [development README](https://github.com/jonatas/rubocop/blob/master/manual/development.md) which might help a bit, but it's pretty sparse.

Rubocop includes a number of built in linters which it calls "cops" (you can tweak which ones it runs by providing a `.rubocop.yml` file). It doesn't, however, include any that will enforce our specific migration concerns. So let's make one!

Let's take a look at the following Sequel migration:

{% highlight ruby %}
# db/migrations/add_widgets_table.rb
Sequel.migration do
  change do
    create_table(:widgets) do
      String :guid, :index
      String :widget_name, size: 255
      Integer :count
    end
  end
end
{% endhighlight %}

This migration is adding a new `widgets` table that has columns for `guid`, `widget_name`, and `count`. The migration developer wisely decided to add an index on the `guid` column since we'll likely be making a lot of queries using it. There's just one problem... the developer forgot to give this index a name!

This means that the index will have an autogenerated name which could be different across the different database types and it will be difficult to make changes to this index in the future if need be. So let's write a Rubocop cop that will catch this for them next time.

Let's start out by creating a new `linters` directory and the following file within it:
{% highlight ruby %}
# <project-root>/linters/migration/add_index_name.rb
module RuboCop
  module Cop
    module Migration
      class AddIndexName < RuboCop::Cop::Cop

      end
    end
  end
end
{% endhighlight %}

Now, we'll set the message that Rubocop will provide whenever it finds offending lines by setting the `MSG` constant.

{% highlight ruby %}
# <project-root>/linters/migration/add_index_name.rb
module RuboCop
  module Cop
    module Migration
      class AddIndexName < RuboCop::Cop::Cop
        MSG = 'Please explicitly name your index or constraint.'.freeze
      end
    end
  end
end
{% endhighlight %}

Now it's time to get to the actual implementation of our cop. Rubocop analyzes code by using the [parser](https://github.com/whitequark/parser) gem to create an [Abstract Syntax Tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree), or AST, for the code. The following AST represents the migration that we're analyzing:

{% highlight ruby %}
# AST for the "add_widgets_table.rb" migration above
(block
  (send
    (const nil :Sequel) :migration)
  (args)
  (block
    (send nil :change)
    (args)
    (block
      (send nil :create_table
        (sym :widgets))
      (args)
      (begin
        (send nil :String
          (sym :guid)
          (sym :index))
        (send nil :String
          (sym :widget_name)
          (hash
            (pair
              (sym :size)
              (int 255))))
        (send nil :Integer
          (sym :count))))))
{% endhighlight %}

Rubocop uses a handful of methods to traverse the various nodes in these trees. Typically since migrations occur in Ruby blocks, we'll use the `on_block` method that Rubocop provides.

{% highlight ruby %}
# <project-root>/linters/migration/add_index_name.rb
module RuboCop
  module Cop
    module Migration
      class AddIndexName < RuboCop::Cop::Cop
        MSG = 'Please explicitly name your index or constraint.'.freeze

        COLUMN_ADDING_METHODS = %i{ add_column column String Integer }.freeze

        def on_block(node)
          node.each_descendant(:send) do |send_node|
            method = method_name(send_node)
            next unless sequel_column_adding_method?(method)
          end
        end

        private

        def sequel_column_adding_method?(method)
          COLUMN_ADDING_METHODS.include?(method)
        end

        def method_name(node)
          node.children[1]
        end
      end
    end
  end
end
{% endhighlight %}

First we'll start simple. The code above will go through every Ruby block, check the method name, and skip to the next unless we're dealing with one of Sequel's column adding methods (for simplicity we're just checking a subset of them in this cop). We can find the column adding method by looping through each "send" node descendant of the `create_table` block that we're on. The send nodes look like this:

{% highlight ruby %}
(send nil :String
  (sym :guid)
  (sym :index))
{% endhighlight %}

Our `method_name(node)` method extracts the second child from these nodes which happens to be the method name. Since "String" is one of Sequel's column adding methods we've found something to inspect!

Now let's complete our cop:

{% highlight ruby %}
# <project-root>/linters/migration/add_index_name.rb
module RuboCop
  module Cop
    module Migration
      class AddIndexName < RuboCop::Cop::Cop
        MSG = 'Please explicitly name your index or constraint.'.freeze

        COLUMN_ADDING_METHODS = %i{ add_column column String Integer }.freeze

        def on_block(node)
          node.each_descendant(:send) do |send_node|
            method = method_name(send_node)
            next unless sequel_column_adding_method?(method)

            opts = send_node.children.last
            add_offense(send_node, location: :expression) if missing_index_name?(opts)
          end
        end

        private

        def sequel_column_adding_method?(method)
          COLUMN_ADDING_METHODS.include?(method)
        end

        def method_name(node)
          node.children[1]
        end

        def missing_index_name?(opts)
          opts.type == :sym && opts.children[0] == :index
        end
      end
    end
  end
end
{% endhighlight %}

So what's going on here? First if we're found a column adding method we'll extract it's options by grabbing the find child of the `send_node` in the AST that we're on. This works because Sequel's column adding methods typically follow the pattern:
{% highlight ruby %}
ColumnAddingMethod :column_name, :other_options
# e.g. String :guid, :index
{% endhighlight %}

Then the true magic happens in the following line:
{% highlight ruby %}
add_offense(send_node, location: :expression) if missing_index_name?(opts)
{% endhighlight %}

In this very basic implementation of the cop, if we see that the options passed to the method are just a single symbol and that symbol is `:index` then we are clearly missing a name for our index. We then call Rubocop's `add_offense` method with the current AST node that we're on. This will mark the expression as an offending piece of lint and it, along with the `MSG` that we declared earlier, will show up in the output when we run `rubocop`.

Now it's time to make Rubocop aware of our new cop's existence by adding it to the `.rubocop.yml file`:

{% highlight yaml %}
# <project-root>/.rubocop.yml
require:
- ./linters/migration/add_index_name.rb

# ... other config ...
{% endhighlight %}

Then simply run the `rubocop` command:

{% highlight bash %}
$ rubocop

Offenses:

db/migrations/add_widgets_table.rb:4:7: C: Please explicitly name your index or constraint.
      String :guid, :index
      ^^^^^^^^^^^^^^^^^^^^

1 file inspected, 1 offense detected
{% endhighlight %}

Voilà, you've now written a basic Rubocop cop for linting Sequel migrations! The same basic principles apply to Active Record migrations and for writing Rubocop cops in general.

If you're interested in seeing a more complete example of the cop above, check out [add_constraint_name.rb](https://github.com/cloudfoundry/cloud_controller_ng/blob/de02030b848be26c94135facc254a7f585b91d1b/spec/linters/migration/add_constraint_name.rb) in the Cloud Controller repo and its [associated test](https://github.com/cloudfoundry/cloud_controller_ng/blob/de02030b848be26c94135facc254a7f585b91d1b/spec/linters/migration/add_constraint_name_spec.rb).

Hope you found this useful! 😊
