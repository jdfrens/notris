import Config

config :logger, level: :info

config :notris_web, NotrisWeb.Endpoint,
  url: [host: "notris.duringrecess.org", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"
