# Drill Sergeant

Ruby client for Apache Drill

## Installation

First, [download Apache Drill](https://drill.apache.org/docs/installing-drill-on-linux-and-mac-os-x/). Start it with:

```sh
bin/drill-embedded
```

Then add this line to your application’s Gemfile:

```ruby
gem 'drill-sergeant'
```

## How to Use

```ruby
drill = Drill.new(url: "http://localhost:8047")
drill.query("SELECT * FROM dfs.`/path/to/some/file.csvh`")
```

## History

View the [changelog](https://github.com/ankane/drill-sergeant/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/drill-sergeant/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/drill-sergeant/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
