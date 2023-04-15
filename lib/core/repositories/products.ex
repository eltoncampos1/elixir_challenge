defmodule Core.Repositories.Product do
  alias Core.Entities.Product
  alias Core.Repo

  def create(params) do
    %Product{}
    |> Product.changeset(params)
    |> Repo.insert()
  end
end
