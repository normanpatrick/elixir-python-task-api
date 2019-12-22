defmodule MyApp.Repo.Migrations.CreateJsonrpctasks do
  use Ecto.Migration

  def change do
    create table(:jsonrpctasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :status, :string
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:jsonrpctasks, [:name])
  end
end
