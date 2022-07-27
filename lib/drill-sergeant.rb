# stdlib
require "cgi"
require "json"
require "net/http"

# modules
require "drill/client"
require "drill/version"

module Drill
  class Error < StandardError; end

  def self.new(**options)
    Client.new(**options)
  end
end
