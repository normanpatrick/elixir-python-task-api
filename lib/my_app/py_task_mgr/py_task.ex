defmodule MyApp.PyTaskMgr.PyTask do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pytasks" do
    field :description, :string
    field :is_active, :boolean, default: false
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(py_task, attrs) do
    py_task
    |> cast(attrs, [:name, :description, :status, :is_active])
    |> validate_required([:name, :description, :is_active])
    |> unique_constraint(:name)
  end
end
