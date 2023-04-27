defmodule Core do
  alias Core.Repositories.Client, as: ClientRepository
  alias Core.Repositories.Address, as: AddressRepository
  alias Core.Repositories.Product, as: ProductRepository

  @moduledoc """
  Core keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defdelegate create_client(params), to: ClientRepository, as: :create
  defdelegate create_address(params), to: AddressRepository, as: :create
  defdelegate create_product(params), to: ProductRepository, as: :create

  defdelegate get_client_by_id!(id), to: ClientRepository, as: :get_by_id!

  defdelegate signup(params), to: ClientRepository, as: :signup

  defdelegate all_clients, to: ClientRepository, as: :index
  defdelegate get_client_by_id(id), to: ClientRepository, as: :get_by_id

  defdelegate update_client(client, params), to: ClientRepository, as: :update
end
