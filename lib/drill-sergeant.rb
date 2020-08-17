# dependencies
require "cgi"
require "json"
require "net/http"

# modules
require "drill/version"

class Drill
  class Error < StandardError; end

  HEADERS = {
    "Content-Type" => "application/json",
    "Accept" => "application/json"
  }

  def initialize(url: nil, open_timeout: 3, read_timeout: nil)
    url ||= ENV["DRILL_URL"] || "http://localhost:8047"
    # remove trailing slash
    @uri = URI.parse(url.chomp("/"))
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.use_ssl = true if @uri.scheme == "https"
    @http.open_timeout = open_timeout if open_timeout
    @http.read_timeout = read_timeout if read_timeout
  end

  def query(statement)
    data = {
      queryType: "sql",
      query: statement
    }

    body = post("query.json", data)

    # return columns in order
    result = []
    columns = body["columns"]
    body["rows"].each do |row|
      result << columns.each_with_object({}) { |c, memo| memo[c] = row[c] }
    end
    result
  end

  def profiles(query_id = nil)
    path = query_id ? "profiles/#{escape_path(query_id)}.json" : "profiles.json"
    get(path)
  end

  def storage(name = nil)
    path = name ? "storage/#{escape_path(name)}.json" : "storage.json"
    get(path)
  end

  def cluster
    get("cluster.json")
  end

  def metrics
    # no .json suffix
    get("status/metrics")
  end

  def options
    get("options.json")
  end

  private

  def get(path)
    handle_response do
      @http.get("#{@uri.request_uri}#{path}", HEADERS)
    end
  end

  def post(path, data)
    handle_response do
      @http.post("#{@uri.request_uri}#{path}", data.to_json, HEADERS)
    end
  end

  def handle_response
    begin
      response = yield
    rescue Errno::ECONNREFUSED => e
      raise Drill::Error, e.message
    end

    unless response.kind_of?(Net::HTTPSuccess)
      body = JSON.parse(response.body) rescue {}
      message = body["errorMessage"] || "Bad response: #{response.code}"
      raise Drill::Error, message
    end

    JSON.parse(response.body)
  end

  def escape_path(path)
    CGI.escape(path).gsub("+", "%20")
  end
end
