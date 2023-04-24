defmodule CoreWeb.ClientController do
  use CoreWeb, :controller

  action_fallback CoreWeb.FallbackController

  def signup(conn, params) do
    with {:ok, client} <- Core.signup(params) do
      conn
      |> put_status(:ok)
      |> render("new.json", %{client: client})
    end
  end
end
