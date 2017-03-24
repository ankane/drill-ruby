require_relative "test_helper"

class DrillTest < Minitest::Test
  def test_success
    expected = [
      {"state" => "Ohio", "capital" => "Columbus"},
      {"state" => "California", "capital" => "Sacramento"}
    ]
    assert_equal expected, drill.query(good_query)
  end

  def test_column_order
    assert_equal ["state", "capital"], drill.query(good_query).first.keys
  end

  def test_bad_query
    error = assert_raises(Drill::Error) { drill.query("SELECT * FROM bad") }
    assert_includes error.message, "Table 'bad' not found"
  end

  def test_bad_connection
    error = assert_raises(Drill::Error) { Drill.new(url: "http://localhost:8048").query(good_query) }
    assert_includes error.message, "Failed to open TCP connection"
  end

  def good_query
    dir = File.expand_path(File.dirname(__FILE__))
    "SELECT * FROM dfs.`#{dir}/capitals.csvh`"
  end

  def drill
    Drill.new(url: "http://localhost:8047")
  end
end
