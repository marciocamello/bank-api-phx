# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bank_api_phx,
  ecto_repos: [BankApiPhx.Repo]

# Configures the endpoint
config :bank_api_phx, BankApiPhxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mseA3Rvx/isby1nr8l+Scpf3JUXvfe1PI1qlBCESZDNYEmtv5Odd92YpJzr8zb+J",
  render_errors: [view: BankApiPhxWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BankApiPhx.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "6eDXfKDI"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bank_api_phx,
       BankApiPhxWeb.Auth.Guardian,
       error_handler: BankApiPhxWeb.Auth.ErrorHandler,
       issuer: "bank_api_phx",
       secret_key: "PHFDJXbth00fej3TCCPLA6MC3EC9i8JpNh3tK4Ccrm2r5QKyeJMx8zYu+GzceuSq"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
