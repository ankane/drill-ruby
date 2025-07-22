# stdlib
require "cgi/escape"
require "json"
require "net/http"

# modules
require_relative "drill/client"
require_relative "drill/version"

module Drill
  class Error < StandardError; end

  def self.new(**options)
    Client.new(**options)
  end
end
