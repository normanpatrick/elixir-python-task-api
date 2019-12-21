defmodule MyAppWeb.PyTaskView do
  use MyAppWeb, :view
  alias MyAppWeb.PyTaskView

  def render("index.json", %{pytasks: pytasks}) do
    render_many(pytasks, PyTaskView, "py_task.json")
  end

  def render("show.json", %{py_task: py_task}) do
    render_one(py_task, PyTaskView, "py_task.json")
  end

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end

  def render("info.json", %{info: info}) do
    info
  end

  def render("py_task.json", %{py_task: py_task}) do
    %{id: py_task.id,
      name: py_task.name,
      description: py_task.description,
      status: py_task.status,
      created: py_task.inserted_at,
      is_active: py_task.is_active}
  end
end
