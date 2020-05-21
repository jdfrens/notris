import Config

config :logger, :console, format: "[$level] $message\n"

config :notris_web, NotrisWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../apps/notris_web/assets", __DIR__)
    ]
  ]

config :notris_web, NotrisWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/notris_web/(live|views)/.*(ex)$",
      ~r"lib/notris_web/templates/.*(eex)$"
    ]
  ]

config :phoenix, :plug_init_mode, :runtime

config :phoenix, :stacktrace_depth, 20
