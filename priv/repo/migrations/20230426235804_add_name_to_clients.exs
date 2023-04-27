defmodule Core.Repo.Migrations.AddNameToClients do
  use Ecto.Migration

  def change do
    alter table(:clients) do
      add :name, :string
    end
  end
end
