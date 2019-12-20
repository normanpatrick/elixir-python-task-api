defmodule MyApp.PyTaskMgr do
  @moduledoc """
  The PyTaskMgr context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.PyTaskMgr.PyTask

  @doc """
  Returns the list of pytasks.

  ## Examples

      iex> list_pytasks()
      [%PyTask{}, ...]

  """
  def list_pytasks do
    Repo.all(PyTask)
  end

  @doc """
  Gets a single py_task.

  Raises `Ecto.NoResultsError` if the Py task does not exist.

  ## Examples

      iex> get_py_task!(123)
      %PyTask{}

      iex> get_py_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_py_task!(id), do: Repo.get!(PyTask, id)

  @doc """
  Creates a py_task.

  ## Examples

      iex> create_py_task(%{field: value})
      {:ok, %PyTask{}}

      iex> create_py_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_py_task(attrs \\ %{}) do
    %PyTask{}
    |> PyTask.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a py_task.

  ## Examples

      iex> update_py_task(py_task, %{field: new_value})
      {:ok, %PyTask{}}

      iex> update_py_task(py_task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_py_task(%PyTask{} = py_task, attrs) do
    py_task
    |> PyTask.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PyTask.

  ## Examples

      iex> delete_py_task(py_task)
      {:ok, %PyTask{}}

      iex> delete_py_task(py_task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_py_task(%PyTask{} = py_task) do
    Repo.delete(py_task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking py_task changes.

  ## Examples

      iex> change_py_task(py_task)
      %Ecto.Changeset{source: %PyTask{}}

  """
  def change_py_task(%PyTask{} = py_task) do
    PyTask.changeset(py_task, %{})
  end

  def lrt_sample_task(id, how_many_seconds) do
    IO.puts("[#{id}] starting dummy lrt for #{how_many_seconds}s...")
    py_task = get_py_task!(id)
    IO.inspect(py_task)
    for i <- 0..how_many_seconds do
      :timer.sleep(1000)
      status = "[#{id}] at #{i} seconds"
      IO.puts(status)
      update_py_task(py_task, %{status: status})
      IO.inspect(get_py_task!(id))
    end
  end
end
