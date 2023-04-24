defmodule CoreTest do
  use Core.DataCase
  alias Core.Entities
  alias Core.Entities.Client

  @valid_client_params %{
    email: "valid@email.com",
    password: "12345678"
  }

  describe "Create client" do
    test "Create client" do
      assert {:ok, %Client{email: client_email}} = Core.create_client(@valid_client_params)

      assert client_email == @valid_client_params.email
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
end
