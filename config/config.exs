# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :core,
  ecto_repos: [Core.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :core, CoreWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CoreWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Core.PubSub,
  live_view: [signing_salt: "M+3bH+33"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :core, Core.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :money, default_currency: :BRL

config :core, CoreWeb.Auth.Adapters.AuthHandler.Guardian,
  issuer: "core",
  secret_key: System.get_env("GUARDIAN_AUTH_TOKEN")

# ADAPTERS
config :core, CoreWeb.Auth.Ports.AuthHandler, adapter: CoreWeb.Auth.Adapters.AuthHandler.Guardian

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
