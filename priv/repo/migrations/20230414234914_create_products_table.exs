defmodule Core.Repo.Migrations.CreateProductsTable do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :price, :integer
      add :description, :string
      add :reference_image, :string
      add :client_id, references(:clients, type: :binary_id)
      timestamps()
    end
  end
end
