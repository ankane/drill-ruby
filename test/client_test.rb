require_relative "test_helper"

class ClientTest < Minitest::Test
  def test_success
    expected = [
      {"state" => "Ohio", "capital" => "Columbus"},
      {"state" => "California", "capital" => "Sacramento"}
    ]
    assert_equal expected, drill.query(good_query)
  end

  def test_limit
    expected = [
      {"state" => "Ohio", "capital" => "Columbus"}
    ]
    assert_equal expected, drill.query(good_query, limit: 1)
  end

  def test_column_order
    assert_equal ["state", "capital"], drill.query(good_query).first.keys
  end

  def test_same_name_columns
    assert_equal ["state", "state0", "state1"], drill.query(good_query(columns: "state, state, state")).first.keys
  end

  def test_bad_query
    error = assert_raises(Drill::Error) do
      drill.query("SELECT * FROM bad")
    end
    assert_includes error.message, "Object 'bad' not found"
  end

  def test_bad_connection
    error = assert_raises(Drill::Error) do
      Drill.new(url: "http://localhost:8048").query(good_query)
    end
    assert_includes error.message, "Failed to open TCP connection"
  end

  def test_profiles
    skip "Failed to get profiles error with Drill 1.18.0+"

    response = drill.profiles
    assert response["finishedQueries"]
  end

  def test_profiles_query_id
    skip "Failed to get profiles error with Drill 1.18.0+"

    drill.query("SELECT 1")
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

  def test_disable_storage
    response = drill.disable_storage("cp")
    assert_equal "Success", response["result"]

    response = drill.storage("cp")
    assert_nil response["config"]["enabled"]
  ensure
    response = drill.enable_storage("cp")
    assert_equal "Success", response["result"]

    response = drill.storage("cp")
    assert_equal true, response["config"]["enabled"]
  end

  def test_update_storage
    response =
      drill.update_storage(
        "test",
        type: "file",
        enabled: true,
        connection: "file:///",
        workspaces: {"tmp"=>{"location"=>"/tmp", "writable"=>true, "defaultInputFormat"=>nil, "allowAccessOutsideWorkspace"=>false}},
        formats: {"json"=>{"type"=>"json", "extensions"=>["json"]}}
      )
    assert_equal "Success", response["result"]
  ensure
    drill.delete_storage("test")
  end

  def test_delete_storage_missing
    assert_raises do
      drill.delete_storage("missing")
    end
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

  def test_inspect
    drill = Drill.new(url: "http://user:secret@localhost:8048")
    refute_match "secret", drill.inspect
    refute_match "secret", drill.to_s
  end

  private

  def good_query(columns: "*")
    dir = File.expand_path(__dir__)
    "SELECT #{columns} FROM dfs.`#{dir}/capitals.csvh`"
  end

  def drill
    @drill ||= Drill.new
  end
end
