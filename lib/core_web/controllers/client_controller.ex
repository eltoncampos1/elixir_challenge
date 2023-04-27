defmodule CoreWeb.ClientController do
  use CoreWeb, :controller

  action_fallback CoreWeb.FallbackController

  def signup(conn, params) do
    with {:ok, client} <- Core.signup(params) do
      conn
      |> put_status(201)
      |> render("new.json", %{client: client})
    end
  end

  def index(conn, _params) do
    with clients <- Core.all_clients() do
      conn
      |> put_status(:ok)
      |> render("index.json", clients: clients)
    end
  end
end
