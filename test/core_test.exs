defmodule CoreTest do
  use Core.DataCase
  alias Core.Entities
  alias Core.Entities.Client

  import Core.Factory

  @valid_client_params %{
    email: "valid@email.com",
    password: "12345678",
    name: "core_user"
  }

  describe "Create client" do
    test "Create client" do
      assert {:ok, %Client{email: client_email}} = Core.create_client(@valid_client_params)

      assert client_email == @valid_client_params.email
    end

    test "error on create client if is not correct email format" do
      params = %{
        email: "invalid_email.com",
        password: "1234567",
        name: "username"
      }

      assert {
               :error,
               %Ecto.Changeset{errors: [email: {"has invalid format", [validation: :format]}]}
             } = Core.create_client(params)
    end

    test "error on create client if password has invalid length" do
      params = %{
        email: "valid@email.com",
        password: "1234",
        name: "username"
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

  describe "Create address" do
    test "create address" do
      {:ok, %{id: client_id} = client} = Core.create_client(@valid_client_params)

      params = %{
        cep: "09409310",
        state: "SP",
        city: "SP",
        number: "20",
        client: client
      }

      assert {:ok, %Entities.Address{client_id: ^client_id}} = Core.create_address(params)
    end

    test "Error if same client already has a address registered" do
      {:ok, %{id: client_id} = client} = Core.create_client(@valid_client_params)

      params1 = %{
        cep: "09409310",
        state: "SP",
        city: "SP",
        number: "20",
        client: client
      }

      assert {:ok, %Entities.Address{client_id: ^client_id}} = Core.create_address(params1)

      params2 = %{
        cep: "09417310",
        state: "SP",
        city: "SP",
        number: "10",
        client: client
      }

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  client_id:
                    {"has already been taken",
                     [constraint: :unique, constraint_name: "addresses_client_id_index"]}
                ]
              }} = Core.create_address(params2)
    end

    test "error if CEP has invalid length" do
      {:ok, client} = Core.create_client(@valid_client_params)

      params = %{
        cep: "0940",
        state: "SP",
        city: "SP",
        number: "20",
        client: client
      }

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  cep:
                    {"should be %{count} character(s)",
                     [count: 8, validation: :length, kind: :is, type: :string]}
                ]
              }} = Core.create_address(params)
    end

    test "error if has missing params" do
      {:ok, client} = Core.create_client(@valid_client_params)

      params = %{
        cep: "09243891",
        city: "SP",
        number: "20",
        client: client
      }

      assert {:error,
              %Ecto.Changeset{errors: [state: {"can't be blank", [validation: :required]}]}} =
               Core.create_address(params)
    end
  end

  describe "Create products" do
    test "create products" do
      {:ok, %{id: client_id} = client} = Core.create_client(@valid_client_params)

      params = %{
        price: Money.new(1000),
        description: "A amazing product, with good acessories, and cheap price for you",
        reference_image: "image.png",
        client: client
      }

      assert {:ok, %Entities.Product{client_id: ^client_id}} = Core.create_product(params)
    end

    test "error if product descripton is less than 20 digits" do
      {:ok, client} = Core.create_client(@valid_client_params)

      params = %{
        price: Money.new(1000),
        description: "A amazing product",
        reference_image: "image.png",
        client: client
      }

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  description:
                    {"should be at least %{count} character(s)",
                     [count: 20, validation: :length, kind: :min, type: :string]}
                ]
              }} = Core.create_product(params)
    end
  end

  describe "get_client_by_id!/1" do
    test "should be able to get an valid client given id" do
      %{id: id, name: name, email: email} = insert(:client)

      assert %Client{id: ^id, name: ^name, email: ^email} = Core.get_client_by_id!(id)
    end

    test "should raise if invalid id is provided" do
      assert_raise Ecto.NoResultsError, fn -> Core.get_client_by_id!(Ecto.UUID.generate()) end
      assert_raise Ecto.Query.CastError, fn -> Core.get_client_by_id!("invalid") end
    end
  end

  describe "get_client_by_id/1" do
    test "should be able to get an valid client given id" do
      %{id: id, name: name, email: email} = insert(:client)

      assert {:ok, %Client{id: ^id, name: ^name, email: ^email}} = Core.get_client_by_id(id)
    end

    test "should return error if invalid id is provided" do
      assert {:error, :not_found} = Core.get_client_by_id(Ecto.UUID.generate())
    end
  end

  describe "all_clients/0" do
    test "should be able to return all clients" do
      total = 10

      for i <- 1..total,
          do:
            Core.create_client(%{
              email: "email-#{i}@email.com",
              name: "client #{i}",
              password: "123456"
            })

      assert [%Client{} | _tail] = clients = Core.all_clients()
      assert length(clients) == total
    end

    test "should return empty array in has no clients" do
      assert [] = Core.all_clients()
    end
  end

  describe "update_client/2" do
    test "should be able to update a client" do
      c_1 = insert(:client)
      new_params = %{email: "new_email@email.com", name: "new_name"}

      assert {:ok, %Client{} = client} = Core.update_client(c_1, new_params)
      assert client.email == new_params.email
      assert client.name == new_params.name
      assert c_1.id == client.id
    end

    test "should return error if wrong params are passed" do
      c_1 = insert(:client)
      new_params = %{email: "new_email.com", name: "new_name"}

      assert {:error,
              %Ecto.Changeset{
                valid?: false,
                errors: [email: {"has invalid format", [validation: :format]}]
              }} = Core.update_client(c_1, new_params)
    end

    test "should return error invalid client are passed" do
      c_1 = insert(:client)
      new_params = %{email: "new_email@email.com", name: "new_name"}

      assert_raise Ecto.NoPrimaryKeyValueError, fn ->  Core.update_client(%Client{}, new_params) end
    end
  end
end
