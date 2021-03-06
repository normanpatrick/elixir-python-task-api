defmodule MyAppWeb.JsonRpcTaskControllerTest do
  use MyAppWeb.ConnCase

  alias MyApp.JsonRpcTaskContext
  alias MyApp.JsonRpcTaskContext.JsonRpcTask

  @create_attrs %{
    description: "some description",
    is_active: true,
    name: "some name",
    status: "some status"
  }
  @update_attrs %{
    description: "some updated description",
    is_active: false,
    name: "some updated name",
    status: "some updated status"
  }
  @invalid_attrs %{description: nil, is_active: nil, name: nil, status: nil}

  def fixture(:json_rpc_task) do
    {:ok, json_rpc_task} = JsonRpcTaskContext.create_json_rpc_task(@create_attrs)
    json_rpc_task
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all jsonrpctasks", %{conn: conn} do
      conn = get(conn, Routes.json_rpc_task_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create json_rpc_task" do
    test "renders json_rpc_task when data is valid", %{conn: conn} do
      conn = post(conn, Routes.json_rpc_task_path(conn, :create), json_rpc_task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.json_rpc_task_path(conn, :show, id))

      assert %{
        "id" => id,
        "description" => "some description",
        "is_active" => true,
        "name" => "some name",
        "status" => "some status"
      } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.json_rpc_task_path(conn, :create), json_rpc_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update json_rpc_task" do
    setup [:create_json_rpc_task]

    @tag :skip
    test "renders json_rpc_task when data is valid", %{conn: conn, json_rpc_task: %JsonRpcTask{id: id} = json_rpc_task} do
      conn = put(conn, Routes.json_rpc_task_path(conn, :update, json_rpc_task), json_rpc_task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.json_rpc_task_path(conn, :show, id))

      assert %{
        "id" => id,
        "description" => "some updated description",
        "is_active" => false,
        "name" => "some updated name",
        "status" => "some updated status"
      } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, json_rpc_task: json_rpc_task} do
      conn = put(conn, Routes.json_rpc_task_path(conn, :update, json_rpc_task), json_rpc_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete json_rpc_task" do
    setup [:create_json_rpc_task]

    test "deletes chosen json_rpc_task", %{conn: conn, json_rpc_task: json_rpc_task} do
      conn = delete(conn, Routes.json_rpc_task_path(conn, :delete, json_rpc_task))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.json_rpc_task_path(conn, :show, json_rpc_task))
      end
    end
  end

  describe "jsonrpc call tests" do
    # wahoo - fixme: hardcoded stuff
    @url "http://localhost:5000/"
    @url_hook "http://localhost:4000/api/lrthook"

    test "invoke a simple py task rpc call" do
      res = JsonRpcTaskContext.rpc_invoke(@url,
        "ping",
        %{param1: "ex-p1",
          param2: 1001.23})
      assert {:ok, ["pong", %{"param1" => "ex-p1", "param2" => 1001.23}]} = res
    end
    test "invoke simple_task but print args and complete" do
      assert {:ok, nil} = JsonRpcTaskContext.rpc_invoke(@url,
        "sample_task",
        %{task_id: 123,
          how_many_seconds: 4,
          url_hook: @url_hook,
          is_sync_task: true})
    end

    test "py task rpc call, py will do webhook req", %{conn: conn} do
      # first, creat a task-entry in db and get the id
      conn = post(conn, Routes.py_task_path(conn, :create_task_entry_only),
        py_task: %{ description: "rpc task",
                    is_active: true,
                    name: "rpc-task-1",
                    status: "task created over rpc"
        })
      assert %{"id" => id} = json_response(conn, 201)
      IO.inspect(id, label: "using id:")
      assert {:ok, nil} =
        JsonRpcTaskContext.rpc_invoke(@url, "sample_task",
          %{task_id: id,
            how_many_seconds: 6,
            url_hook: @url_hook,
            is_sync_task: false})
    end
  end

  defp create_json_rpc_task(_) do
    json_rpc_task = fixture(:json_rpc_task)
    {:ok, json_rpc_task: json_rpc_task}
  end
end
