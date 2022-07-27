# stdlib
require "cgi"
require "json"
require "net/http"

# modules
require "drill/version"

# TODO make module and move to client
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
    options = {}
    if Gem::Version.new(server_version) >= Gem::Version.new("1.19.0")
      options["drill.exec.http.rest.errors.verbose"] = true
    end
    run_query(statement, options)
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

  def server_version
    @server_version ||= run_query("SELECT version FROM sys.version", {})[0]["version"]
  end

  # @uri may contain sensitive info
  def inspect
    to_s
  end

  private

  def run_query(statement, options)
    data = {
      queryType: "sql",
      query: statement,
      options: options
    }

    body = post("query.json", data)

    # errors return 200 with Drill 1.19+
    if body["queryState"] != "COMPLETED"
      raise Error, body["errorMessage"] || "Bad state: #{body["queryState"]}"
    end

    # return columns in order
    result = []
    columns = body["columns"]
    body["rows"].each do |row|
      result << columns.each_with_object({}) { |c, memo| memo[c] = row[c] }
    end
    result
  end

  def get(path)
    handle_response do
      Net::HTTP::Get.new("#{@uri.request_uri}#{path}", HEADERS)
    end
  end

  def post(path, data)
    handle_response do
      req = Net::HTTP::Post.new("#{@uri.request_uri}#{path}", HEADERS)
      req.body = data.to_json
      req
    end
  end

  def handle_response
    begin
      req = yield
      req.basic_auth(@uri.user, @uri.password) if @uri.user || @uri.password
      response = @http.request(req)
    rescue Errno::ECONNREFUSED => e
      raise Error, e.message
    end

    unless response.kind_of?(Net::HTTPSuccess)
      body = JSON.parse(response.body) rescue {}
      message = body["errorMessage"] || "Bad response: #{response.code}"
      raise Error, message
    end

    JSON.parse(response.body)
  end

  def escape_path(path)
    CGI.escape(path).gsub("+", "%20")
  end
end
