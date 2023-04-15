defmodule Core.Repo.Migrations.CreateAdressesTable do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext", "DROP EXTENSION citext")

    create table(:addresses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cep, :string
      add :state, :string
      add :city, :string
      add :number, :string

      add :client_id, references(:clients, type: :binary_id)
      timestamps()
    end
  end
end
