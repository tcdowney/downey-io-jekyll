FROM ubuntu:focal

ENV LANG=C.UTF-8 \
    RUBY_VERSION=2.7.6 \
    TZ=America/Los_Angeles \
    DEBIAN_FRONTEND=noninteractive

# Dependencies for Ruby
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
    python2 \
    tzdata \
    git \
    curl \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    autoconf \
    bison \
    build-essential \
    libyaml-dev \
    libreadline-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm-dev \
    rbenv \
    ; \
	rm -rf /var/lib/apt/lists/*;

# Install Ruby and configure rbenv
RUN mkdir -p "$(rbenv root)"/plugins
RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

RUN rbenv install ${RUBY_VERSION}
RUN rbenv global ${RUBY_VERSION}
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Install Java 8
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
    openjdk-8-jdk openjdk-8-jre \
    fontconfig libfreetype6 \
    ca-certificates p11-kit \
    ; \
	rm -rf /var/lib/apt/lists/*;

# Pre-install most gems
WORKDIR gemfiles
COPY Gemfile* .
ENV BUNDLE_SILENCE_ROOT_WARNING=1
RUN eval "$(rbenv init -)" && bundle install

# Remove the Gemfiles we copied so that they don't cause confusion
WORKDIR /
RUN rm -rf /gemfiles

RUN cp ~/.bashrc .bashrc

CMD [ "/bin/bash" ]