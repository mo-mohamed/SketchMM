# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sketch,
  ecto_repos: [Sketch.Repo]

# Configures the endpoint
config :sketch, SketchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "joQoUwu38S+zTHpIuZBGk51lASi8m9IaP9mTHM6PwTcHRJt67ibsYLDE/iE4gIKU",
  render_errors: [view: SketchWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Sketch.PubSub,
  live_view: [signing_salt: "puIB3eRg"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
