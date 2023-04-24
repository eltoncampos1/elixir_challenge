defmodule CoreTest do
  use Core.DataCase
  alias Core.Entities.Client

  test "Create client" do
    params = %{
      email: "test@email.com",
      password: "1234567"
    }

    assert {:ok, %Client{email: client_email}} = Core.create_client(params)

    assert client_email == params.email
  end

  test "error on create client if is not correct email format" do
    params = %{
      email: "invalid_email.com",
      password: "1234567"
    }

    assert {
             :error,
             %Ecto.Changeset{errors: [email: {"has invalid format", [validation: :format]}]}
           } = Core.create_client(params)
  end

  test "error on create client if password has invalid length" do
    params = %{
      email: "valid@email.com",
      password: "1234"
    }

    assert {
             :error,
             %Ecto.Changeset{
               errors: [
                 password:
                   {"should be at least %{count} character(s)",
                    [count: 6, validation: :length, kind: :min, type: :string]}
               ]
             }
           } = Core.create_client(params)
  end
end
