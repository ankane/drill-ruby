require_relative "test_helper"

class ClientTest < Minitest::Test
  def test_bad_connection
    error = assert_raises(Drill::Error) do
      Drill.new(url: "http://localhost:8048").query("SELECT 1")
    end
    assert_includes error.message, "Failed to open TCP connection"
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
end
