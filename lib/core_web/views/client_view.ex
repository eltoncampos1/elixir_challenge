defmodule CoreWeb.ClientView do
  use CoreWeb, :view

  def render("new.json", %{client: %{address: address} = client}) do
    %{
      id: client.id,
      email: client.email,
      name: client.name,
      address: render_one(address, CoreWeb.AddressView, "new.json", as: :address)
    }
  end

  def render("index.json", %{clients: clients}) do
    %{
      clients: render_many(clients, __MODULE__, "new.json")
    }
  end
end
