defmodule Core.Repo.Migrations.AddUniqueIndexForClientAddress do
  use Ecto.Migration

  def change do
    create unique_index(:addresses, [:client_id])
  end
end
