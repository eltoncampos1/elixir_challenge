defmodule Core.Entities.Client do
  use Core.BaseSchema

  @required [:email, :password]

  schema "clients" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

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