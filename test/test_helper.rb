require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"

class Minitest::Test
  def drill
    @drill ||= Drill::Client.new
  end
end
