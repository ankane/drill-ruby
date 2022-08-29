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

## Getting Started

Create a client

```ruby
drill = Drill::Client.new(url: "http://localhost:8047")
```

And query away

```ruby
drill.query("SELECT * FROM dfs.`/path/to/some/file.csvh`")
```

## Endpoints

[API docs](https://drill.apache.org/docs/rest-api-introduction/)

### Query

Run a query

```ruby
drill.query(
  query,
  limit: nil,
  default_schema: nil,
  username: nil
)
```

### Profiles

Get profiles of running and completed queries

```ruby
drill.profiles
```

Get the profile of a query

```ruby
drill.profiles(query_id)
```

Cancel a query

```ruby
drill.cancel_query(query_id)
```

### Storage

List storage plugins

```ruby
drill.storage
```

Get a storage plugin by name

```ruby
drill.storage(name)
```

Enable a storage plugin

```ruby
drill.enable_storage(name)
```

Disable a storage plugin

```ruby
drill.disable_storage(name)
```

Create or update a storage plugin

```ruby
drill.update_storage(
  name,
  type: nil,
  enabled: nil,
  connection: nil,
  workspaces: nil,
  formats: nil
)
```

Delete a storage plugin

```ruby
drill.delete_storage(name)
```

### Info

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
Drill::Client.new(open_timeout: 5, read_timeout: 120)
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
