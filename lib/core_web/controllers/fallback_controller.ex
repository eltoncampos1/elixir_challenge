defmodule CoreWeb.FallbackController do
  use CoreWeb, :controller

  def call(conn, {:error, %{reason: :badarg}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("422.json")
  end

  def call(conn, {:error, %{kind: kind, reason: reason}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("422.json", %{errors: %{kind: kind, reason: reason}})
  end

  def call(conn, {:error, %{message: message}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("422.json", %{errors: %{message: message}})
  end

  def call(conn, {:error, %{errors: errors}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("422.json", %{errors: errors})
  end

  def call(conn, {:error, %{changes: changes}}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("422.json", %{errors: changes})
  end

  def not_found(conn, _opts) do
    conn
    |> put_status(:not_found)
    |> render("404.json")
  end

  def conflict(conn, _opts) do
    conn
    |> put_status(:conflict)
    |> render("409.json")
  end

  def unprocessable_entity(conn, _opts) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("422.json")
  end

  def bad_request(conn, _opts) do
    conn
    |> put_status(:bad_request)
    |> render("400.json")
  end

  def internal_server_error(conn, _opts) do
    conn
    |> put_status(:internal_server_error)
    |> render("500.json")
  end
end
