require_relative "test_helper"

class QueryTest < Minitest::Test
  def test_query
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

  private

  def good_query(columns: "*")
    dir = File.expand_path(__dir__)
    "SELECT #{columns} FROM dfs.`#{dir}/capitals.csvh`"
  end
end
