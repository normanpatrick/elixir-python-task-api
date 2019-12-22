defmodule MyAppWeb.JsonRpcTaskView do
  use MyAppWeb, :view
  alias MyAppWeb.JsonRpcTaskView

  def render("index.json", %{jsonrpctasks: jsonrpctasks}) do
    %{data: render_many(jsonrpctasks, JsonRpcTaskView, "json_rpc_task.json")}
  end

  def render("show.json", %{json_rpc_task: json_rpc_task}) do
    %{data: render_one(json_rpc_task, JsonRpcTaskView, "json_rpc_task.json")}
  end

  def render("json_rpc_task.json", %{json_rpc_task: json_rpc_task}) do
    %{id: json_rpc_task.id,
      name: json_rpc_task.name,
      description: json_rpc_task.description,
      status: json_rpc_task.status,
      is_active: json_rpc_task.is_active}
  end
end
