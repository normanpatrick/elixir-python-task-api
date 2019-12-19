defmodule MyApp.CLRTManager.SLRTask do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "slrtasks" do
    field :description, :string
    field :is_active, :boolean, default: false
    field :name, :string
    field :status, :string

    # microseconds timestamp for this specific schema
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(slr_task, attrs) do
    slr_task
    |> cast(attrs, [:name, :description, :is_active, :status])
    |> validate_required([:name, :description, :is_active])
    |> unique_constraint(:name)
  end
end
