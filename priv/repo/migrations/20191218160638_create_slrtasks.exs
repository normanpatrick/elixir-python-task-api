defmodule MyApp.Repo.Migrations.CreateSlrtasks do
  use Ecto.Migration

  def change do
    create table(:slrtasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:slrtasks, [:name])
  end
end
