defmodule MyAppWeb.SLRTaskController do
  use MyAppWeb, :controller

  alias MyApp.CLRTManager
  alias MyApp.CLRTManager.SLRTask

  action_fallback MyAppWeb.FallbackController

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc}#{k}: #{joined_errors}\n"
    end)
  end

  def index(conn, _params) do
    slrtasks = CLRTManager.list_slrtasks()
    render(conn, "index.json", slrtasks: slrtasks)
  end

  def create(conn, %{"slr_task" => slr_task_params}) do
    # params = Map.put(slr_task_params, "status", "just created")
    params = slr_task_params
    # IO.inspect(params, label: "wahoo3")
    case CLRTManager.create_slr_task(params) do
    {:ok, %SLRTask{} = slr_task} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.slr_task_path(conn, :show, slr_task))
        |> render("show.json", slr_task: slr_task)
      {:error, %Ecto.Changeset{} = echangeset } ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", errors: translate_errors(echangeset))
    end
  end

  def show(conn, %{"id" => id}) do
    case CLRTManager.get_slr_task(id) do
      %SLRTask{} = slr_task ->
        render(conn, "show.json", slr_task: slr_task)
      nil ->
        conn
        |> put_status(:not_found)
        |> render("error.json", errors: %{error: "record could not be found"})
    end
  end

  def update(conn, %{"id" => id, "slr_task" => slr_task_params}) do
    slr_task = CLRTManager.get_slr_task(id)

    with {:ok, %SLRTask{} = slr_task} <- CLRTManager.update_slr_task(slr_task, slr_task_params) do
      render(conn, "show.json", slr_task: slr_task)
    end
  end

  def delete(conn, %{"id" => id}) do
    slr_task = CLRTManager.get_slr_task(id)

    with {:ok, %SLRTask{}} <- CLRTManager.delete_slr_task(slr_task) do
      send_resp(conn, :no_content, "")
    end
  end
end
