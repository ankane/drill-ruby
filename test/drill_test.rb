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
    response = drill.profiles
    assert response["finishedQueries"]
  end

  def test_profiles_query_id
    query_id = drill.profiles["finishedQueries"][0]["queryId"]
    response = drill.profiles(query_id)
    assert response
  end

  def test_storage
    assert_kind_of Array, drill.storage
  end

  def test_storage_name
    response = drill.storage("cp")
    assert_equal "cp", response["name"]
  end

  def test_storage_name_invalid
    response = drill.storage("hello world")
    assert_nil response["config"]

    response = drill.storage("hello&?world")
    assert_nil response["config"]
  end

  def test_cluster
    response = drill.cluster
    assert response["drillbits"]
  end

  def test_metrics
    response = drill.metrics
    assert response["version"]
  end

  def test_options
    response = drill.options
    assert_kind_of Array, response
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
