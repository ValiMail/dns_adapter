ARG RUBY_VERSION=3.3

FROM ruby:${RUBY_VERSION}-slim

ARG BUNDLER_VERSION=2.6.9
ARG DEBIAN_FRONTEND=noninteractive

ENV BUNDLE_APP_CONFIG=/bundle/config \
    BUNDLE_JOBS=4 \
    BUNDLE_PATH=/bundle \
    BUNDLE_RETRY=3

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential ca-certificates git \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile dns_adapter.gemspec ./
COPY lib/dns_adapter/version.rb lib/dns_adapter/version.rb

RUN gem install bundler -v "$BUNDLER_VERSION" \
  && bundle install

COPY . .

CMD ["bundle", "exec", "rspec"]
