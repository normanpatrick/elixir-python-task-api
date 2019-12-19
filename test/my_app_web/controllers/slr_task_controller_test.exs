defmodule MyAppWeb.SLRTaskControllerTest do
  use MyAppWeb.ConnCase

  alias MyApp.CLRTManager
  alias MyApp.CLRTManager.SLRTask

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
  @invalid_attrs %{
    description: nil,
    is_active: nil,
    name: nil,
    status: nil
  }

  def fixture(:slr_task) do
    {:ok, slr_task} = CLRTManager.create_slr_task(@create_attrs)
    slr_task
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all slrtasks", %{conn: conn} do
      conn = get(conn, Routes.slr_task_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create slr_task" do
    test "renders slr_task when data is valid", %{conn: conn} do
      conn = post(conn,
        Routes.slr_task_path(conn, :create),
        slr_task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.slr_task_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "is_active" => true,
               "name" => "some name",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.slr_task_path(conn, :create), slr_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update slr_task" do
    setup [:create_slr_task]

    @tag skip: "wahoo: update action is disabled at resources"
    test "renders slr_task when data is valid", %{conn: conn, slr_task: %SLRTask{id: id} = slr_task} do
      conn = put(conn, Routes.slr_task_path(conn, :update, slr_task), slr_task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.slr_task_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "is_active" => false,
               "name" => "some updated name",
               "status" => "some status"
             } = json_response(conn, 200)["data"]
    end

    @tag skip: "wahoo: update action is disabled at resources"
    test "renders errors when data is invalid", %{conn: conn, slr_task: slr_task} do
      conn = put(conn, Routes.slr_task_path(conn, :update, slr_task), slr_task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete slr_task" do
    setup [:create_slr_task]

    @tag skip: "wahoo: update action is disabled at resources"
    test "deletes chosen slr_task", %{conn: conn, slr_task: slr_task} do
      conn = delete(conn, Routes.slr_task_path(conn, :delete, slr_task))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.slr_task_path(conn, :show, slr_task))
      end
    end
  end

  defp create_slr_task(_) do
    slr_task = fixture(:slr_task)
    {:ok, slr_task: slr_task}
  end
end
