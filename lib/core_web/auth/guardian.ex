defmodule CoreWeb.Auth.Guardian do
  use Guardian, otp_app: :core

  alias Core.Entities.Client
  alias Core.Repositories.Client, as: ClientRepository

  def authenticate(%{"email" => email, "password" => password}) do
    case ClientRepository.authenticate(email, password) do
      {:ok, client} -> create_token(client)
      _ -> {:error, :unauthorized}
    end
  end

  def subject_for_token(%Client{} = client, _claims) do
    {:ok, to_string(client.id)}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Core.get_client_by_id(id) do
      %Client{} = client -> {:ok, client}
      _ -> {:error, :resource_not_found}
    end
  end

  defp create_token(client) do
    {:ok, token, _claim} = encode_and_sign(client)

    {:ok, client, token}
  end
end
