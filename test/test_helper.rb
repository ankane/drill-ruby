require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

class Minitest::Test
  def drill
    @drill ||= Drill::Client.new
  end
end
