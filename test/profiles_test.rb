require_relative "test_helper"

class ProfilesTest < Minitest::Test
  def test_profiles
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

  def test_cancel_query
    skip "todo: fix"

    query_id = drill.profiles["finishedQueries"][0]["queryId"]
    drill.cancel_query(query_id)
  end
end
