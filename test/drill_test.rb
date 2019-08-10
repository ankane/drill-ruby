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

  def test_same_name_columns
    assert_equal ["state", "state0", "state1"], drill.query(good_query(columns: "state, state, state")).first.keys
  end

  def test_bad_query
    error = assert_raises(Drill::Error) { drill.query("SELECT * FROM bad") }
    assert_includes error.message, "Object 'bad' not found"
  end

  def test_bad_connection
    error = assert_raises(Drill::Error) { Drill.new(url: "http://localhost:8048").query(good_query) }
    assert_includes error.message, "Failed to open TCP connection"
  end

  def test_profiles
    assert_kind_of Hash, drill.profiles
  end

  def test_storage
    assert_kind_of Array, drill.storage
  end

  def test_cluster
    assert_kind_of Hash, drill.cluster
  end

  def test_metrics
    assert_kind_of Hash, drill.metrics
  end

  def test_options
    assert_kind_of Array, drill.options
  end

  private

  def good_query(columns: "*")
    dir = File.expand_path(File.dirname(__FILE__))
    "SELECT #{columns} FROM dfs.`#{dir}/capitals.csvh`"
  end

  def drill
    Drill.new(url: "http://localhost:8047")
  end
end
