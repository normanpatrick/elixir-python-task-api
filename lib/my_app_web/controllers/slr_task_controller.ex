defmodule MyAppWeb.SLRTaskController do
  use MyAppWeb, :controller

  alias MyApp.CLRTManager
  alias MyApp.CLRTManager.SLRTask

  action_fallback MyAppWeb.FallbackController

  def index(conn, _params) do
    slrtasks = CLRTManager.list_slrtasks()
    render(conn, "index.json", slrtasks: slrtasks)
  end

  def create(conn, %{"slr_task" => slr_task_params}) do
    with {:ok, %SLRTask{} = slr_task} <- CLRTManager.create_slr_task(slr_task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.slr_task_path(conn, :show, slr_task))
      |> render("show.json", slr_task: slr_task)
    end
  end

  def show(conn, %{"id" => id}) do
    slr_task = CLRTManager.get_slr_task!(id)
    render(conn, "show.json", slr_task: slr_task)
  end

  def update(conn, %{"id" => id, "slr_task" => slr_task_params}) do
    slr_task = CLRTManager.get_slr_task!(id)

    with {:ok, %SLRTask{} = slr_task} <- CLRTManager.update_slr_task(slr_task, slr_task_params) do
      render(conn, "show.json", slr_task: slr_task)
    end
  end

  def delete(conn, %{"id" => id}) do
    slr_task = CLRTManager.get_slr_task!(id)

    with {:ok, %SLRTask{}} <- CLRTManager.delete_slr_task(slr_task) do
      send_resp(conn, :no_content, "")
    end
  end
end
