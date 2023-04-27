defmodule CoreWeb.SessionController do
  use CoreWeb, :controller

  alias Core.Entities.Client
  alias CoreWeb.Auth.Ports.AuthHandler

  alias CoreWeb.ErrorView

  action_fallback CoreWeb.FallbackController

  def authenticate(conn, %{"email" => _email, "password" => _pass} = params) do
    with {:ok, %Client{} = client, token} <- AuthHandler.authenticate(params) do
      conn
      |> put_status(201)
      |> render("new.json", %{client: client, token: token})
    end
   end

  def authenticate(conn, _params) do
    conn
    |> put_status(400)
    |> put_view(ErrorView)
    |> render(:bad_request)
  end
end
