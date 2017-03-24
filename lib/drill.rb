require "json"
require "net/http"
require "drill/version"

class Drill
  class Error < StandardError; end

  def initialize(url: nil)
    url ||= ENV["DRILL_URL"] || "http://localhost:8047"
    @uri = URI.parse("#{url}/query.json")
    @http = Net::HTTP.new(@uri.host, @uri.port)
  end

  def query(statement)
    header = {"Content-Type" => "application/json", "Accept" => "application/json"}
    data = {
      queryType: "sql",
      query: statement
    }

    begin
      response = @http.post(@uri.request_uri, data.to_json, header)
    rescue Errno::ECONNREFUSED => e
      raise Drill::Error, e.message
    end

    body = JSON.parse(response.body)
    if body["errorMessage"]
      raise Drill::Error, body["errorMessage"].split("\n")[0]
    end

    # return columns in order
    result = []
    columns = body["columns"]
    body["rows"].each do |row|
      result << Hash[columns.map { |c| [c, row[c]] }]
    end
    result
  end
end
