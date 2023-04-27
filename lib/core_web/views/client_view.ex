defmodule CoreWeb.ClientView do
  use CoreWeb, :view

  def render("new.json", %{client: client}) do
    %{
      id: client.id,
      email: client.email,
      name: client.name
    }
  end
end
