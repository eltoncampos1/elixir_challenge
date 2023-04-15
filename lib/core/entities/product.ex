defmodule Core.Entities.Product do
  use Core.BaseSchema

  @required [:price, :reference_image, :description, :client_id]

  schema "products" do
    field :price, Money.Ecto.Amount.Type
    field :description, :string
    field :reference_image, :string
    belongs_to :client, Core.Entities.Client

    timestamps()
  end

  def changeset(product, params) do
    product
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_length(:description, min: 20)
    |> foreign_key_constraint(:client_id)
  end
end
