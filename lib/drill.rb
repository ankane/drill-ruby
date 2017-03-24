require "json"
require "net/http"
require "drill/version"

class Drill
  class Error < StandardError; end

  HEADERS = {
    "Content-Type" => "application/json",
    "Accept" => "application/json"
  }

  def initialize(url: nil)
    url ||= ENV["DRILL_URL"] || "http://localhost:8047"
    # strip trailing slash if exists
    @uri = URI.parse("#{url.sub(/\/\z/, "")}/query.json")
    @http = Net::HTTP.new(@uri.host, @uri.port)
  end

  def query(statement)
    data = {
      queryType: "sql",
      query: statement
    }

    begin
      response = @http.post(@uri.request_uri, data.to_json, HEADERS)
    rescue Errno::ECONNREFUSED => e
      raise Drill::Error, e.message
    end

    body = JSON.parse(response.body)
    if body["errorMessage"]
      raise Drill::Error, body["errorMessage"].split("\n")[0]
    end

    body
  end
end
