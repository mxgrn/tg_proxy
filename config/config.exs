import Config

config :tg_proxy,
  proxy_port: System.get_env("PROXY_PORT", "4000") |> String.to_integer(),
  target_host: System.get_env("TARGET_HOST", "localhost"),
  target_port: System.get_env("TARGET_PORT", "8080") |> String.to_integer()

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]