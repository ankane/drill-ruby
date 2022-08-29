require_relative "lib/drill/version"

Gem::Specification.new do |spec|
  spec.name          = "drill-sergeant"
  spec.version       = Drill::VERSION
  spec.summary       = "Ruby client for Apache Drill"
  spec.homepage      = "https://github.com/ankane/drill-ruby"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 2.7"
end
