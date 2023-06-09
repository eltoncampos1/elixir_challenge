defmodule CoreWeb.Router do
  use CoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug CoreWeb.Auth.Pipeline
  end

  scope "/api", CoreWeb do
    pipe_through :api

    post "/signup", ClientController, :signup
    post "/session", SessionController, :authenticate
    post "/validate", ClientController, :validate

    scope "/" do
      pipe_through :auth

      resources "/users", ClientController, except: [:new, :create]
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
