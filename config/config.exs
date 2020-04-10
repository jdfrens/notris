use Mix.Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :notris_web,
  generators: [context_app: :notris]

config :notris_web, NotrisWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t2R77uUzhS/ThmewVMDZFia/dvGEHebwSqI19SpOfmgaaZ2zUMBOlMMxh9AVX6r1",
  render_errors: [view: NotrisWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NotrisWeb.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "rl8lUYfl"]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
