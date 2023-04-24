defmodule CoreWeb.Auth.Pipeline do
  alias CoreWeb.Auth

  use Guardian.Plug.Pipeline,
    otp_app: :core,
    module: Auth.Guardian,
    error_handle: Auth.ErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug Guardian.Plug.EnsureAuthenticated
end
