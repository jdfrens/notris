import Config

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :notris_web,
  generators: [context_app: :notris]

config :notris_web, NotrisWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t2R77uUzhS/ThmewVMDZFia/dvGEHebwSqI19SpOfmgaaZ2zUMBOlMMxh9AVX6r1",
  render_errors: [view: NotrisWeb.ErrorView, accepts: ~w(html json)],
  live_view: [signing_salt: "5EQuyE3WKtPS3lWEmS8B0FZILUi0Q11S"],
  pubsub_server: NotrisWeb.PubSub

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
