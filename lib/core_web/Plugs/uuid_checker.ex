defmodule CoreWeb.Plugs.UUIDChecker do
  import Plug.Conn

  def init(default), do: default

  def call(%Plug.Conn{params: %{"id" => id}} = conn, _default) do
    case Ecto.UUID.cast(id) do
      {:ok, _uuid} ->
        conn

      _ ->
        conn
        |> put_resp_content_type("Application/Json")
        |> resp(401, Jason.encode!(%{"errors" => %{"detail" => "invalid format"}}))
        |> halt()
    end
  end
end
