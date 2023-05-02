defmodule CoreWeb.ClientController do
  use CoreWeb, :controller
  plug CoreWeb.Plugs.UUIDChecker when action in [:show, :edit]

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

  def edit(conn, %{"id" => client_id} = params) do
    with {:ok, client} <- Core.get_client_by_id(client_id),
         {:ok, updated_client} <- Core.update_client(client, params) do
      conn
      |> put_status(201)
      |> render("edit.json", client: updated_client)
    end
  end

  def validate(conn, %{"email" => email}) do
    case Core.get_client_by_email(email) do
      %Core.Entities.Client{} -> {:error, :already_exists}
      _ ->  conn
      |> put_status(:ok)
      |> json(%{valid: true})
    end
  end
end
