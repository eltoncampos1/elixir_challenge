defmodule Core.Repositories.Client do
  alias Core.Entities.Client
  alias Core.Repo
  alias Ecto.Multi

  def create(params) do
    %Client{}
    |> Client.changeset(params)
    |> Repo.insert()
  end

  def get_by_id!(id) do
    Repo.get!(Client, id)
  end

  def authenticate(email, password) do
    Repo.get_by(Client, email: email)
    |> verify_hash(password)
  end

  defp verify_hash(%Client{} = client, password) do
    if Argon2.verify_pass(password, client.password_hash) do
      {:ok, client}
    else
      {:error, :unauthorized}
    end
  end

  defp verify_hash(_, _password), do: {:error, :not_found}

  def signup(params) do
    Multi.new()
    |> Multi.run(:client, fn _repo, _any ->
      create(params.client)
    end)
    |> Multi.run(:address, fn _repo, %{client: %{id: id}} ->
      params
      |> build_address_params(id)
      |> Core.create_address()
    end)
    |> Repo.transaction()
  end

  defp build_address_params(%{address: address}, id), do: Map.put(address, :client_id, id)
end
