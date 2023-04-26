defmodule CoreWeb.SessionView do
  use CoreWeb, :view
  alias CoreWeb.ClientView

  def render("new.json", %{client: client, token: token}) do
    %{
      client: render_one(client, ClientView, "new.json", as: :client),
      token: token
    }
  end
end
