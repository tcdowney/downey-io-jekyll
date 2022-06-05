downey-io
=========

This repo contains the static Jekyll sites that live under my `downey.io` domain.  Currently that consists of my [blog](http://downey.io) and my [photo blog](http://photo.downey.io).

---

## Developing
The tech stack used to build this site is really starting to show its age. Jekyll is still fine, but the way it's using Sprockets, therubyracer, Ruby SASS, s3_website etc. really doesn't play nicely with modern systems -- especially my M1 Mac.

One day I should get around to rewriting it in a more modern stack, but for now I've got it "working" in Docker running in amd64 mode via QEMU, but it's not the best. Anyways, for my own sake these are the steps for building and running in Docker on an M1 Mac.

### Building the Image
The libv8/therubyracer gems were giving me trouble on arm64, so I am building and running the image for amd64. This is very slow on my machine. I also had issue with Ruby 3 and the latest and greatest Jammy Jellyfish LTS of Ubuntu, so I'm falling back to Ruby 2.7.x and Focal for now.

```console
docker buildx build . --tag downey/jekyll-env --platform=linux/amd64
```

Why not just use a pre-built Ruby image? The s3_website gem I'm using to publish to AWS requires the Java 8 JDK to run, so it's easier to just start with Ubuntu.

### Running the Image

```console
docker run --platform=linux/amd64 -p 8000:8000 -it --entrypoint=/bin/bash -v $PWD:/downey-io downey/jekyll-env
```

From there the regular `rake` commands should just work for publishing.

### Issues

`jekyll serve` doesn't work on my M1 Mac within the Docker container because QEMU doesn't support inotify. It gives an error like this:
```
/root/.rbenv/versions/2.7.6/lib/ruby/gems/2.7.0/gems/rb-inotify-0.10.1/lib/rb-inotify/notifier.rb:69:in `initialize': Function not implemented - Failed to initialize inotify (Errno::ENOSYS)
```

I imagine it should work fine on a regular amd64 host, but on an M1 Mac I've resorted to using `jekyll build` followed up with a regular Ruby server like `ruby -run -e httpd _site -p 8000`