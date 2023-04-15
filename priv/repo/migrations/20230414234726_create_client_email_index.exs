defmodule Core.Repo.Migrations.CreateClientEmailIndex do
  use Ecto.Migration

  def change do
    create unique_index(:clients, [:email])
  end
end
