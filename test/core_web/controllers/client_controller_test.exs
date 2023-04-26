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

      response =
        conn
        |> post(Routes.client_path(conn, :signup), params)
        |> json_response(201)

      assert %{"email" => "valid@email.com", "id" => _user_id} = response
    end

    test "return 400 with errors with wrong params on client", %{conn: conn} do
      params = %{
        client: %{
          email: "invalidemail.com",
          password: "1234"
        },
        address: %{
          cep: "00000000",
          state: "SP",
          city: "SP",
          number: "00"
        }
      }

      response =
        conn
        |> post(Routes.client_path(conn, :signup), params)
        |> json_response(422)

      assert %{
               "errors" => %{
                 "email" => ["has invalid format"],
                 "password" => ["should be at least 6 character(s)"]
               },
               "status" => "failure"
             } = response
    end

    test "return 400 with errors with wrong params o address", %{conn: conn} do
      params = %{
        client: %{
          email: "valid@email.com",
          password: "12345678"
        },
        address: %{
          cep: "00000",
          state: "SP",
          city: "SP",
          number: "00"
        }
      }

      response =
        conn
        |> post(Routes.client_path(conn, :signup), params)
        |> json_response(422)

      assert %{"errors" => %{"cep" => ["should be 8 character(s)"]}, "status" => "failure"} =
               response
    end
  end
end
