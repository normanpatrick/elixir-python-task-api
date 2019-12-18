defmodule MyApp.CLRTManager do
  @moduledoc """
  The CLRTManager context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.CLRTManager.SLRTask

  @doc """
  Returns the list of slrtasks.

  ## Examples

      iex> list_slrtasks()
      [%SLRTask{}, ...]

  """
  def list_slrtasks do
    Repo.all(SLRTask)
  end

  @doc """
  Gets a single slr_task.

  Raises `Ecto.NoResultsError` if the Slr task does not exist.

  ## Examples

      iex> get_slr_task!(123)
      %SLRTask{}

      iex> get_slr_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_slr_task!(id), do: Repo.get!(SLRTask, id)

  @doc """
  Creates a slr_task.

  ## Examples

      iex> create_slr_task(%{field: value})
      {:ok, %SLRTask{}}

      iex> create_slr_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_slr_task(attrs \\ %{}) do
    %SLRTask{}
    |> SLRTask.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a slr_task.

  ## Examples

      iex> update_slr_task(slr_task, %{field: new_value})
      {:ok, %SLRTask{}}

      iex> update_slr_task(slr_task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_slr_task(%SLRTask{} = slr_task, attrs) do
    slr_task
    |> SLRTask.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SLRTask.

  ## Examples

      iex> delete_slr_task(slr_task)
      {:ok, %SLRTask{}}

      iex> delete_slr_task(slr_task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_slr_task(%SLRTask{} = slr_task) do
    Repo.delete(slr_task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking slr_task changes.

  ## Examples

      iex> change_slr_task(slr_task)
      %Ecto.Changeset{source: %SLRTask{}}

  """
  def change_slr_task(%SLRTask{} = slr_task) do
    SLRTask.changeset(slr_task, %{})
  end
end
