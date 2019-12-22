defmodule MyApp.JsonRpcTaskContext.JsonRpcTask do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "jsonrpctasks" do
    field :description, :string
    field :is_active, :boolean, default: false
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(json_rpc_task, attrs) do
    json_rpc_task
    |> cast(attrs, [:name, :description, :status, :is_active])
    |> validate_required([:name, :description, :status, :is_active])
    |> unique_constraint(:name)
  end
end
