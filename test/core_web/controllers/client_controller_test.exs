defmodule CoreWeb.ClientControllerTest do
  use CoreWeb.ConnCase, async: true

 setup %{conn: conn} do
    params = %{email: "valid@email.com", password: "1234567", name: "valid_user"}
    {:ok, client} = Core.create_client(params)
    %{conn: conn, params: params, client: client}
  end

  describe "POST signup" do
    test "return 200 with client created", %{conn: conn} do
      params = %{
        client: %{
          email: "valid2@email.com",
          password: "1234567",
          name: "username"
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

      assert %{"email" => "valid2@email.com", "id" => _user_id, "name" => "username"} = response
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

    test "return 400 with errors with wrong params on address", %{conn: conn} do
      params = %{
        client: %{
          email: "valid2@email.com",
          password: "12345678",
          name: "user_name"
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

  # describe "GET index/2" do
  #   test "Should return all clients", %{conn: conn, client: client} do



  #       conn
  #       |> authenticate_user(client)
  #       |> get(Routes.client_path(conn, :index))
  #       |> json_response(422)
  #   end
  # end

  defp authenticate_user(conn, client) do
    {:ok, token, _} = Guardian.encode_and_sign(client)
    conn
    |> put_req_header("authorization", "Bearer #{token}")
  end
end
