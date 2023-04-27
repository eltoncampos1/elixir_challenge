defmodule CoreWeb.SessionView do
  use CoreWeb, :view

  def render("auth.json", %{token: token}) do
    %{
      token: token
    }
  end
end
