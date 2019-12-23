defmodule MyApp.JsonRpcTaskContext do
  @moduledoc """
  The JsonRpcTaskContext context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.JsonRpcTaskContext.JsonRpcTask
  alias JSONRPC2.Clients.HTTP

  @doc """
  Returns the list of jsonrpctasks.

  ## Examples

      iex> list_jsonrpctasks()
      [%JsonRpcTask{}, ...]

  """
  def list_jsonrpctasks do
    Repo.all(JsonRpcTask)
  end

  @doc """
  Gets a single json_rpc_task.

  Raises `Ecto.NoResultsError` if the Json rpc task does not exist.

  ## Examples

      iex> get_json_rpc_task!(123)
      %JsonRpcTask{}

      iex> get_json_rpc_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_json_rpc_task!(id), do: Repo.get!(JsonRpcTask, id)

  @doc """
  Creates a json_rpc_task.

  ## Examples

      iex> create_json_rpc_task(%{field: value})
      {:ok, %JsonRpcTask{}}

      iex> create_json_rpc_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_json_rpc_task(attrs \\ %{}) do
    %JsonRpcTask{}
    |> JsonRpcTask.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a json_rpc_task.

  ## Examples

      iex> update_json_rpc_task(json_rpc_task, %{field: new_value})
      {:ok, %JsonRpcTask{}}

      iex> update_json_rpc_task(json_rpc_task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_json_rpc_task(%JsonRpcTask{} = json_rpc_task, attrs) do
    json_rpc_task
    |> JsonRpcTask.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a JsonRpcTask.

  ## Examples

      iex> delete_json_rpc_task(json_rpc_task)
      {:ok, %JsonRpcTask{}}

      iex> delete_json_rpc_task(json_rpc_task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_json_rpc_task(%JsonRpcTask{} = json_rpc_task) do
    Repo.delete(json_rpc_task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking json_rpc_task changes.

  ## Examples

      iex> change_json_rpc_task(json_rpc_task)
      %Ecto.Changeset{source: %JsonRpcTask{}}

  """
  def change_json_rpc_task(%JsonRpcTask{} = json_rpc_task) do
    JsonRpcTask.changeset(json_rpc_task, %{})
  end

  @doc """
  Make a call with the client to the server, using named args

  Examples in json_rpc_task_controller_test.exs
  """
  def rpc_invoke(url, fn_name, args) do
    opts = [] # [{:hackney.recv_timeout, 10_000}]
    x = HTTP.call(url,
      fn_name,
      Map.new(args),
      hackney_opts: opts)
    IO.inspect(x, label: "hackney-x")
  end

end
