defmodule Core.Factory do
  use ExMachina.Ecto, repo: Core.Repo
  alias Core.Entities.Client

  @default_passwords for i <- 1..5, do: "password-#{i}"
  @default_hashed_passwords @default_passwords
                            |> Enum.map(&{&1, Argon2.hash_pwd_salt(&1)})
                            |> Map.new()

  def client_factory do
    password = Enum.random(@default_passwords)

    hashe_password =
      case {password, Map.get(@default_hashed_passwords, password)} do
        {nil, _} -> nil
        {_, nil} -> Argon2.hash_pwd_salt(password)
        {_, hash} -> hash
      end

    %Client{
      email: "core@email.com",
      password: password,
      name: "core_user",
      password_hash: hashe_password
    }
  end
end
