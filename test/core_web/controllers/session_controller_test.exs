defmodule CoreWeb.SessionControllerTest do
  use CoreWeb.ConnCase, async: true

  setup %{conn: conn} do
    params = %{email: "valid@email.com", password: "1234567", name: "username"}
    {:ok, client} = Core.create_client(params)
    %{conn: conn, client: client, params: params}
  end

  describe "authenticate/2" do
    test "should authenticate user with correct payload", %{conn: conn, params: params} do
      params = %{email: params.email, password: params.password}

      response =
        conn
        |> post(Routes.session_path(conn, :authenticate), params)
        |> json_response(201)

      assert %{"token" => _} = response
    end

    test "should not authenticate user with incorrect payload", %{conn: conn} do
      invalid_user_params = %{email: "user@not_exist.com", password: "1234567"}

      response =
        conn
        |> post(Routes.session_path(conn, :authenticate), invalid_user_params)
        |> json_response(401)

      assert %{"errors" => %{"detail" => "Unauthorized"}} = response
    end

    test "should not authenticate user with  missing payload", %{conn: conn} do
      response =
        conn
        |> post(Routes.session_path(conn, :authenticate), %{})
        |> json_response(400)

      assert %{"errors" => %{"detail" => "Internal Server Error"}} = response
    end
  end
end
