defmodule Core.Repositories.Address do
  alias Core.Entities.Address
  alias Core.Repo

  def create(params) do
    %Address{}
    |> Address.changeset(params)
    |> Repo.insert()
  end
end
