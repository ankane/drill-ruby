require_relative "test_helper"

class StorageTest < Minitest::Test
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
end
