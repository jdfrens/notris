use Mix.Config

config :notris_web, NotrisWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
