defmodule CoreWeb.ClientControllerTest do
  use CoreWeb.ConnCase, async: true

  describe "POST signup" do
    test "return 200 with client created", %{conn: conn} do
      params = %{
        client: %{
          email: "valid@email.com",
          password: "1234567"
        },
        address: %{
          cep: "00000000",
          state: "SP",
          city: "SP",
          number: "00"
        }
      }

      conn
      |> post(Routes.client_path(conn, :signup), params)
      |> json_response(200)
      |> IO.inspect()
    end
  end
end
