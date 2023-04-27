defmodule Core.Factory do
  use ExMachina.Ecto, repo: Core.Repo
  alias Core.Entities.Client

  def client_factory do
    %Client{
      email: "core@email.com",
      password: "1234567",
      name: "core_user"
    }
  end
end
