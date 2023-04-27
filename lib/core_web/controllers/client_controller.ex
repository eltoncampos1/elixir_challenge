defmodule CoreWeb.ClientController do
  use CoreWeb, :controller
  plug CoreWeb.Plugs.UUIDChecker, :id when action in [:show]

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

  def show(conn, %{"id" => client_id}) do
    with {:ok, client} <- Core.get_client_by_id(client_id) do
      conn
      |> put_status(:ok)
      |> render("new.json", client: client)
    end
  end
end
