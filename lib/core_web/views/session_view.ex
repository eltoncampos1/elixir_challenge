defmodule CoreWeb.SessionView do
  use CoreWeb, :view
  alias CoreWeb.ClientView

  def render("auth.json", %{client: client, token: token}) do
    %{
      client: render_one(client, ClientView, "auth.json", as: :client),
      token: token
    }
  end
end
