defmodule MyApp.JsonRpcTaskContextTest do
  use MyApp.DataCase

  alias MyApp.JsonRpcTaskContext

  describe "jsonrpctasks" do
    alias MyApp.JsonRpcTaskContext.JsonRpcTask

    @valid_attrs %{description: "some description", is_active: true, name: "some name", status: "some status"}
    @update_attrs %{description: "some updated description", is_active: false, name: "some updated name", status: "some updated status"}
    @invalid_attrs %{description: nil, is_active: nil, name: nil, status: nil}

    def json_rpc_task_fixture(attrs \\ %{}) do
      {:ok, json_rpc_task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> JsonRpcTaskContext.create_json_rpc_task()

      json_rpc_task
    end

    test "list_jsonrpctasks/0 returns all jsonrpctasks" do
      json_rpc_task = json_rpc_task_fixture()
      assert JsonRpcTaskContext.list_jsonrpctasks() == [json_rpc_task]
    end

    test "get_json_rpc_task!/1 returns the json_rpc_task with given id" do
      json_rpc_task = json_rpc_task_fixture()
      assert JsonRpcTaskContext.get_json_rpc_task!(json_rpc_task.id) == json_rpc_task
    end

    test "create_json_rpc_task/1 with valid data creates a json_rpc_task" do
      assert {:ok, %JsonRpcTask{} = json_rpc_task} = JsonRpcTaskContext.create_json_rpc_task(@valid_attrs)
      assert json_rpc_task.description == "some description"
      assert json_rpc_task.is_active == true
      assert json_rpc_task.name == "some name"
      assert json_rpc_task.status == "some status"
    end

    test "create_json_rpc_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = JsonRpcTaskContext.create_json_rpc_task(@invalid_attrs)
    end

    test "update_json_rpc_task/2 with valid data updates the json_rpc_task" do
      json_rpc_task = json_rpc_task_fixture()
      assert {:ok, %JsonRpcTask{} = json_rpc_task} = JsonRpcTaskContext.update_json_rpc_task(json_rpc_task, @update_attrs)
      assert json_rpc_task.description == "some updated description"
      assert json_rpc_task.is_active == false
      assert json_rpc_task.name == "some updated name"
      assert json_rpc_task.status == "some updated status"
    end

    test "update_json_rpc_task/2 with invalid data returns error changeset" do
      json_rpc_task = json_rpc_task_fixture()
      assert {:error, %Ecto.Changeset{}} = JsonRpcTaskContext.update_json_rpc_task(json_rpc_task, @invalid_attrs)
      assert json_rpc_task == JsonRpcTaskContext.get_json_rpc_task!(json_rpc_task.id)
    end

    test "delete_json_rpc_task/1 deletes the json_rpc_task" do
      json_rpc_task = json_rpc_task_fixture()
      assert {:ok, %JsonRpcTask{}} = JsonRpcTaskContext.delete_json_rpc_task(json_rpc_task)
      assert_raise Ecto.NoResultsError, fn -> JsonRpcTaskContext.get_json_rpc_task!(json_rpc_task.id) end
    end

    test "change_json_rpc_task/1 returns a json_rpc_task changeset" do
      json_rpc_task = json_rpc_task_fixture()
      assert %Ecto.Changeset{} = JsonRpcTaskContext.change_json_rpc_task(json_rpc_task)
    end
  end
end
