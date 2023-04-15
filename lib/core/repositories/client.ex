defmodule Core.Repositories.Client do
  alias Core.Entities.Client
  alias Core.Repo

  def create(params) do
    %Client{}
    |> Client.changeset(params)
    |> Repo.insert()
  end
end
