defmodule CoreWeb.Auth.ErrorHandler do
  use CoreWeb, :controller

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{error: to_string(type)}))
  end
end
