# Drill Sergeant

Ruby client for Apache Drill

[![Build Status](https://travis-ci.org/ankane/drill-sergeant.svg?branch=master)](https://travis-ci.org/ankane/drill-sergeant)

## Installation

First, [install Apache Drill](https://drill.apache.org/docs/installing-drill-on-linux-and-mac-os-x/). For Homebrew, use:

```sh
brew install apache-drill
drill-embedded
```

Then add this line to your application’s Gemfile:

```ruby
gem 'drill-sergeant'
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

## Endpoints [master]

[API docs](https://drill.apache.org/docs/rest-api-introduction/)

Get profiles

```ruby
drill.profiles
```

Get profile by query id

```ruby
drill.profiles(query_id)
```

Get storage

```ruby
drill.storage
```

Get storage by name

```ruby
drill.storage(name)
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

View the [changelog](https://github.com/ankane/drill-sergeant/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/drill-sergeant/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/drill-sergeant/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
