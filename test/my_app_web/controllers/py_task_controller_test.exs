defmodule MyAppWeb.PyTaskControllerTest do
  use MyAppWeb.ConnCase

  alias MyApp.PyTaskMgr
  alias MyApp.PyTaskMgr.PyTask

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

  def fixture(:py_task) do
    {:ok, py_task} = PyTaskMgr.create_py_task(@create_attrs)
    py_task
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all pytasks", %{conn: conn} do
      conn = get(conn, Routes.py_task_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "delete lrt entries" do
    test "clear all lrt", %{conn: conn} do
      conn = get(conn, Routes.py_task_path(conn, :lrt_clear))
      assert %{"count" => 0} = json_response(conn, 200)
    end
  end
  describe "lrt hook related tests" do
    test "test lrt hook with valid data update", %{conn: conn} do
      # create a record, get the id and the do update
      conn = post(conn,
        Routes.py_task_path(conn, :lrt_create),
        py_task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)
      # now call the hook with proper id
      conn = post(conn,
        Routes.py_task_path(conn, :lrt_hook),
        %{Map.put(@create_attrs, :id, id) | status: "good status"})
      # for debug puposes, the hook reflects anything we send
      assert %{"description" => "some description",
               "is_active" => true,
               "name" => "some name",
               "status" => "good status"} = json_response(conn, 200)
    end
    test "test lrt hook with bad data, no :id", %{conn: conn} do
      conn = post(conn,
        Routes.py_task_path(conn, :lrt_hook), @create_attrs)
      assert %{"errors" => errors} = json_response(conn, 422)
    end
  end
  describe "create elixir task (lrt)" do
    test "renders lrt when data is valid", %{conn: conn} do
      conn = post(conn,
        Routes.py_task_path(conn, :lrt_create),
        py_task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.py_task_path(conn, :lrt_show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "is_active" => true,
               "name" => "some name",
               "status" => "some status"
      } = json_response(conn, 200)
      # since LRT is async, let's wait for a short time here
      :timer.sleep(1500)
    end
  end

  describe "create py_task" do
    test "renders py_task when data is valid", %{conn: conn} do
      conn = post(conn, Routes.py_task_path(conn, :create), py_task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.py_task_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "is_active" => true,
               "name" => "some name",
               "status" => "some status"
      } = json_response(conn, 200)
      # since LRT is async, let's wait for a short time here
      :timer.sleep(1500)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.py_task_path(conn, :create), py_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update py_task" do
    setup [:create_py_task]

    @tag :skip
    test "renders py_task when data is valid", %{conn: conn, py_task: %PyTask{id: id} = py_task} do
      conn = put(conn, Routes.py_task_path(conn, :update, py_task), py_task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.py_task_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "is_active" => false,
               "name" => "some updated name",
               "status" => "some updated status"
             } = json_response(conn, 200)
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, py_task: py_task} do
      conn = put(conn, Routes.py_task_path(conn, :update, py_task), py_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete py_task" do
    setup [:create_py_task]

    test "deletes chosen py_task", %{conn: conn, py_task: py_task} do
      conn = delete(conn, Routes.py_task_path(conn, :delete, py_task))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.py_task_path(conn, :show, py_task))
      end
    end
  end

  describe "sync pytask tests" do
    test "valid req to do a sync task", %{conn: conn} do
      conn = post(conn, Routes.py_task_path(conn, :task_sync_create),
        %{jobname: "test1"})
      assert %{"res" => "test1 was completed", "rc" => 0} = json_response(conn, 200)
    end
    test "invalid req must fail", %{conn: conn} do
      conn = post(conn, Routes.py_task_path(conn, :task_sync_create),
        %{nonsense: "test1"})
      assert %{"errors" => %{"msg" => "missing fields, must provide a jobname"}} =
        json_response(conn, 422)
    end
  end

  describe "keeping track of active tasks" do
    test "create one active task", %{conn: conn} do
      conn = post(conn, Routes.py_task_path(conn, :create_task_entry_only),
        py_task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.py_task_path(conn, :index))
      tasks = json_response(conn, 200)
      assert true = Enum.any?(tasks, fn x -> x["is_active"] == true end)
    end
    test "create non-active task", %{conn: conn} do
      conn = post(conn, Routes.py_task_path(conn, :create_task_entry_only),
        py_task: %{ @create_attrs | is_active: false})
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.py_task_path(conn, :index))
      tasks = json_response(conn, 200)
      assert false == Enum.any?(tasks, fn x -> x["is_active"] == true end)
    end
    test "create no task", %{conn: conn} do
      conn = get(conn, Routes.py_task_path(conn, :index))
      tasks = json_response(conn, 200)
      assert false == Enum.any?(tasks, fn x -> x["is_active"] == true end)
    end
  end

  defp create_py_task(_) do
    py_task = fixture(:py_task)
    {:ok, py_task: py_task}
  end
end
