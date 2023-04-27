defmodule Core.Entities.Client do
  use Core.BaseSchema

  @required [:name, :email, :password]

  schema "clients" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_one :address, Core.Entities.Address
    has_many :products, Core.Entities.Product
    timestamps()
  end

  def changeset(client, params) do
    client
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_length(:password, min: 6, max: 25)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Argon2.add_hash(password, hash_key: :password_hash))
  end

  defp put_password_hash(changeset), do: changeset
end
