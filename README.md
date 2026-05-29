# DNSAdapter

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/ValiMail/dns_adapter/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/ValiMail/dns_adapter/tree/master)
[![Code Climate](https://codeclimate.com/github/ValiMail/dns_adapter/badges/gpa.svg)](https://codeclimate.com/github/ValiMail/dns_adapter)

An adapter layer for DNS queries that makes it simple to swap in different DNS providers.

## Supported Ruby Versions

DNSAdapter supports Ruby 3.3 and newer.

Supported versions
- 3.3
- 3.4
- 4.0

## Installation

To get the latest updates from this repository, add the gem to your application's Gemfile:

```ruby
gem 'dns_adapter', github: 'ValiMail/dns_adapter', branch: 'master'
```

The latest version is no longer published to [RubyGems](https://rubygems.org/).

Then run:

    $ bundle

## Usage

DNSAdapter contains a set of useful adapter classes that present a common set of return types and errors for DNS services. To use the gem, instantiate the desired adapter class.

## Docker

This repository includes a Docker-based test environment so contributors can run the suite without depending on a local Ruby or RVM setup.

Run the default test container:

```sh
docker compose run --rm test
```

Run the test suite against another supported Ruby version:

```sh
DNS_ADAPTER_RUBY_VERSION=3.4 docker compose run --rm --build test
```

Run the local Ruby matrix:

```sh
for ruby in 3.3 3.4 4.0; do
  DNS_ADAPTER_RUBY_VERSION="$ruby" docker compose run --rm --build test
done
```

Open a shell in the same container:

```sh
docker compose run --rm test bash
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dns_adapter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Open a pull request
