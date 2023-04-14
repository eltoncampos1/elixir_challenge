defmodule Core.Repo.Migrations.CreateClientsTable do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext", "DROP EXTENSION citext")

    create table(:clients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :citext
      add :password_hash, :string

      timestamps()
    end
  end
end
