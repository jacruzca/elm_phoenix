# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :elm_phoenix, ecto_repos: [ElmPhoenix.Repo]

# Configures the endpoint
config :elm_phoenix, ElmPhoenixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7UxgiNqFxWnr9mjRMejiiVN3+2E2/yCg6xANQyz1KQgeqpeioscko3siqeJeHsDB",
  render_errors: [view: ElmPhoenixWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ElmPhoenix.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :elm_phoenix, ElmPhoenix.Guardian,
  issuer: "elm_phoenix",
  secret_key: "mKJcJg+4Sjh2coJBBNy4e1fyhq72bkcxJ+ohT0zLjfzRND+pHdAODreCDalmL9iK"
