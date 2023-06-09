defmodule Core.Repositories.Client do
  alias Core.Entities.Client
  alias Core.Repo
  alias Ecto.Multi

  def create(params) do
    %Client{}
    |> Client.changeset(params)
    |> Repo.insert()
  end

  def update(client, params) do
    client
    |> Client.update_changeset(params)
    |> Repo.update()
  end

  def index do
    Repo.all(Client)
    |> Repo.preload(:address)
  end

  def get_by_id(id) do
    case Repo.get(Client, id) do
      %Client{} = client ->
        client = client |> Repo.preload(:address)

        {:ok, client}

      _ ->
        {:error, :not_found}
    end
  end

  def get_by_id!(id) do
    Repo.get!(Client, id)
  end

  def get_by_email(email) do
    Repo.get_by(Client, [email: email])
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
      create(params["client"])
    end)
    |> Multi.run(:address, fn _repo, %{client: client} ->
      params
      |> build_address_params(client)
      |> Core.create_address()
    end)
    |> Repo.transaction()
    |> handle_response()
  end

  defp handle_response({:ok, %{address: _address, client: client}}),
    do: {:ok, client |> Repo.preload(:address)}

  defp handle_response({:error, _entity, changeset, _}), do: {:error, changeset}

  defp build_address_params(%{"address" => address}, client),
    do: Map.put(address, "client", client)
end
