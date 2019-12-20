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
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create elixir task (lrt)" do
    test "renders lrt when data is valid", %{conn: conn} do
      conn = post(conn,
        Routes.py_task_path(conn, :lrt_create),
        py_task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.py_task_path(conn, :lrt_show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "is_active" => true,
               "name" => "some name",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end
  end

  describe "create py_task" do
    test "renders py_task when data is valid", %{conn: conn} do
      conn = post(conn, Routes.py_task_path(conn, :create), py_task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.py_task_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "is_active" => true,
               "name" => "some name",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
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
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.py_task_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "is_active" => false,
               "name" => "some updated name",
               "status" => "some updated status"
             } = json_response(conn, 200)["data"]
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

  defp create_py_task(_) do
    py_task = fixture(:py_task)
    {:ok, py_task: py_task}
  end
end
