defmodule CoreWeb.Auth.Ports.AuthHandler do
  alias Core.Entities.Client
  @adapter Application.compile_env!(:core, [__MODULE__, :adapter])

  @callback authenticate(params :: map()) ::
              {:ok, Client.t(), token :: binary()} | {:error, reason :: term()}

  @spec authenticate(params :: map()) ::
          {:ok, Client.t(), token :: binary()} | {:error, reason :: term()}
  defdelegate authenticate(params), to: @adapter
end
