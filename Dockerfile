# syntax=docker/dockerfile:1.7

ARG RUBY_VERSION=3.3.5
FROM ruby:${RUBY_VERSION}-slim

ENV APP_HOME=/rails \
    LANG=C.UTF-8 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

WORKDIR ${APP_HOME}

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      imagemagick \
      libpq-dev \
      libvips \
      nodejs \
      npm \
      postgresql-client \
 && npm install --global yarn \
 && rm -rf /var/lib/apt/lists/*

ARG BUNDLER_VERSION=2.3.3
RUN gem install bundler -v "${BUNDLER_VERSION}"

COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN mkdir -p /opt/bundle-cache \
 && cp -a /usr/local/bundle/. /opt/bundle-cache/

COPY package.json yarn.lock package-lock.json* ./
RUN if [ -f package-lock.json ]; then npm ci; elif [ -f yarn.lock ]; then yarn install --frozen-lockfile; fi
RUN if [ -d node_modules ]; then \
      mkdir -p /opt/node_modules-cache \
      && cp -a node_modules/. /opt/node_modules-cache/; \
    fi

COPY . .

ENTRYPOINT ["./bin/docker-entrypoint"]
EXPOSE 3000
CMD ["bin/dev"]
