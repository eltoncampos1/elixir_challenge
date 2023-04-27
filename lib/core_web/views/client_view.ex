defmodule CoreWeb.ClientView do
  use CoreWeb, :view

  def render("new.json", %{client: client}) do
    %{
      id: client.id,
      email: client.email,
      name: client.name
    }
  end

  def render("index.json", %{clients: clients}) do
    %{
      clients: render_many(clients, __MODULE__, "new.json", as: :client)
    }
  end
end
