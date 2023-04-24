defmodule Core.Entities.Address do
  use Core.BaseSchema

  @required [:cep, :state, :city, :number]

  schema "addresses" do
    field :cep, :string
    field :state, :string
    field :city, :string
    field :number, :string

    belongs_to :client, Core.Entities.Client

    timestamps()
  end

  def changeset(address, params) do
    address
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_length(:cep, is: 8)
    |> put_assoc(:client, cast_client_from_params(params))
    |> foreign_key_constraint(:client_id)
    |> unique_constraint(:client_id)
  end


  defp cast_client_from_params(%{"client" => client}), do: client
  defp cast_client_from_params(%{client: client}), do: client
end
