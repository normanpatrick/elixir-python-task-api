defmodule MyAppWeb.SLRTaskView do
  use MyAppWeb, :view
  alias MyAppWeb.SLRTaskView

  def render("index.json", %{slrtasks: slrtasks}) do
    %{data: render_many(slrtasks, SLRTaskView, "slr_task.json")}
  end

  def render("show.json", %{slr_task: slr_task}) do
    %{data: render_one(slr_task, SLRTaskView, "slr_task.json")}
  end

  def render("slr_task.json", %{slr_task: slr_task}) do
    %{id: slr_task.id,
      name: slr_task.name,
      description: slr_task.description,
      is_active: slr_task.is_active}
  end
end
