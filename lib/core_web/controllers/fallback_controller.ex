defmodule CoreWeb.FallbackController do
  use CoreWeb, :controller

  require Logger
  alias CoreWeb.{ChangesetView, ErrorView}

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :unprocessable_entity}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> json(ErrorView.translate_error(:unprocessable_entity))
  end

  def call(conn, {:error, {:unprocessable_entity, %{payment: %{return_message: return_message}}}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> json(ErrorView.translate_error(return_message))
  end

  def call(conn, {:error, :unprocessable_entity, message}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> json(ErrorView.translate_error(message))
  end

  def call(conn, {:error, {:unprocessable_entity, message}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> json(ErrorView.translate_error(message))
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render(:"404")
  end

  def call(conn, [_ | _]) do
    conn
    |> put_status(:conflict)
    |> put_view(ErrorView)
    |> render(:"409")
  end

  def call(conn, []) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :file_not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> put_view(ErrorView)
    |> render(:"403")
  end

  def call(conn, {:error, :invalid_password}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render(:"401")
  end

  def call(conn, :error) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render(:"400")
  end

  def call(conn, {:error, code, message}) when is_integer(code) and is_binary(message) do
    conn
    |> put_status(code)
    |> put_view(ErrorView)
    |> json(%{errors: %{detail: message}})
  end

  def call(conn, {:error, _reason, message_map}) when is_map(message_map) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> json(ErrorView.translate_error(message_map))
  end

  def call(conn, {:error, _reason, [message_map]}) when is_map(message_map) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> json(ErrorView.translate_error(message_map))
  end

  def call(conn, {:error, reason}) when is_atom(reason) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> json(ErrorView.translate_error(reason))
  end

  def call(conn, {:error, reason}) when is_map(reason) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> json(ErrorView.translate_error(reason))
  end

  def call(conn, {:error, reason}) do
    Logger.error("Generic error view called, reason #{inspect(reason)}", reason: reason)

    conn
    |> put_status(:internal_server_error)
    |> put_view(ErrorView)
    |> render(:"500")
  end

  def call(conn, generic) do
    Logger.error("Generic error view called, generic #{inspect(generic, pretty: true)}",
      generic: generic
    )

    conn
    |> put_status(:internal_server_error)
    |> put_view(ErrorView)
    |> render(:"500")
  end
end
