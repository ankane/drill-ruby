# Drill Ruby

Ruby client for Apache Drill

[![Build Status](https://github.com/ankane/drill-ruby/workflows/build/badge.svg?branch=master)](https://github.com/ankane/drill-ruby/actions)

## Installation

First, [install Apache Drill](https://drill.apache.org/docs/install-drill-introduction/). For Homebrew, use:

```sh
brew install apache-drill
drill-embedded
```

And add this line to your application’s Gemfile:

```ruby
gem "drill-sergeant"
```

## How to Use

Create a client

```ruby
drill = Drill.new(url: "http://localhost:8047")
```

And query away

```ruby
drill.query("SELECT * FROM dfs.`/path/to/some/file.csvh`")
```

## Endpoints

[API docs](https://drill.apache.org/docs/rest-api-introduction/)

Get profiles

```ruby
drill.profiles
```

Get profile by query id

```ruby
drill.profiles(query_id)
```

Cancel query

```ruby
drill.cancel_query(query_id)
```

Get storage plugins

```ruby
drill.storage
```

Get a storage plugin by name

```ruby
drill.storage(name)
```

Enable a storage plugin [unreleased]

```ruby
drill.enable_storage(name)
```

Disable a storage plugin [unreleased]

```ruby
drill.disable_storage(name)
```

Create or update a storage plugin [unreleased]

```ruby
drill.update_storage(name, **config)
```

Delete a storage plugin [unreleased]

```ruby
drill.delete_storage(name)
```

Get cluster info

```ruby
drill.cluster
```

Get metrics

```ruby
drill.metrics
```

Get options

```ruby
drill.options
```

## Reference

Set timeouts

```ruby
Drill.new(open_timeout: 5, read_timeout: 120)
```

## History

View the [changelog](CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/drill-ruby/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/drill-ruby/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/drill-ruby.git
cd drill-ruby
bundle install
bundle exec rake test
```
