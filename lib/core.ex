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

  defdelegate create_user(params), to: ClientRepository, as: :create
  defdelegate create_address(params), to: AddressRepository, as: :create
  defdelegate create_product(params), to: ProductRepository, as: :create
end
