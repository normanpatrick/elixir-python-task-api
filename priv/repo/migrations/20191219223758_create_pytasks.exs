defmodule MyApp.Repo.Migrations.CreatePytasks do
  use Ecto.Migration

  def change do
    create table(:pytasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :status, :string
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:pytasks, [:name])
  end
end
