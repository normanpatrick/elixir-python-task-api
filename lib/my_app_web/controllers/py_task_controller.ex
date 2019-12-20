defmodule MyAppWeb.PyTaskController do
  use MyAppWeb, :controller

  alias MyApp.PyTaskMgr
  alias MyApp.PyTaskMgr.PyTask

  action_fallback MyAppWeb.FallbackController

  def index(conn, _params) do
    pytasks = PyTaskMgr.list_pytasks()
    render(conn, "index.json", pytasks: pytasks)
  end

  def lrt_create(conn, %{"py_task" => py_task_params}) do
    with {:ok, %PyTask{} = py_task} <- PyTaskMgr.create_py_task(py_task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.py_task_path(conn, :show, py_task))
      |> render("show.json", py_task: py_task)
    end
  end

  def lrt_show(conn, %{"id" => id}) do
    py_task = PyTaskMgr.get_py_task!(id)
    render(conn, "show.json", py_task: py_task)
  end

  def create(conn, %{"py_task" => py_task_params}) do
    with {:ok, %PyTask{} = py_task} <- PyTaskMgr.create_py_task(py_task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.py_task_path(conn, :show, py_task))
      |> render("show.json", py_task: py_task)
    end
  end

  def show(conn, %{"id" => id}) do
    py_task = PyTaskMgr.get_py_task!(id)
    render(conn, "show.json", py_task: py_task)
  end

  def update(conn, %{"id" => id, "py_task" => py_task_params}) do
    py_task = PyTaskMgr.get_py_task!(id)

    with {:ok, %PyTask{} = py_task} <- PyTaskMgr.update_py_task(py_task, py_task_params) do
      render(conn, "show.json", py_task: py_task)
    end
  end

  def delete(conn, %{"id" => id}) do
    py_task = PyTaskMgr.get_py_task!(id)

    with {:ok, %PyTask{}} <- PyTaskMgr.delete_py_task(py_task) do
      send_resp(conn, :no_content, "")
    end
  end
end
