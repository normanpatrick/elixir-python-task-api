defmodule MyAppWeb.JsonRpcTaskController do
  use MyAppWeb, :controller

  alias MyApp.JsonRpcTaskContext
  alias MyApp.JsonRpcTaskContext.JsonRpcTask

  action_fallback MyAppWeb.FallbackController

  def index(conn, _params) do
    jsonrpctasks = JsonRpcTaskContext.list_jsonrpctasks()
    render(conn, "index.json", jsonrpctasks: jsonrpctasks)
  end

  def create(conn, %{"json_rpc_task" => json_rpc_task_params}) do
    with {:ok, %JsonRpcTask{} = json_rpc_task} <- JsonRpcTaskContext.create_json_rpc_task(json_rpc_task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.json_rpc_task_path(conn, :show, json_rpc_task))
      |> render("show.json", json_rpc_task: json_rpc_task)
    end
  end

  def show(conn, %{"id" => id}) do
    json_rpc_task = JsonRpcTaskContext.get_json_rpc_task!(id)
    render(conn, "show.json", json_rpc_task: json_rpc_task)
  end

  def update(conn, %{"id" => id, "json_rpc_task" => json_rpc_task_params}) do
    json_rpc_task = JsonRpcTaskContext.get_json_rpc_task!(id)

    with {:ok, %JsonRpcTask{} = json_rpc_task} <- JsonRpcTaskContext.update_json_rpc_task(json_rpc_task, json_rpc_task_params) do
      render(conn, "show.json", json_rpc_task: json_rpc_task)
    end
  end

  def delete(conn, %{"id" => id}) do
    json_rpc_task = JsonRpcTaskContext.get_json_rpc_task!(id)

    with {:ok, %JsonRpcTask{}} <- JsonRpcTaskContext.delete_json_rpc_task(json_rpc_task) do
      send_resp(conn, :no_content, "")
    end
  end
end
