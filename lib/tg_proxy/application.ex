defmodule TgProxy.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port = Application.get_env(:tg_proxy, :proxy_port, 4000)
    
    children = [
      {Plug.Cowboy, scheme: :http, plug: TgProxy.Router, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: TgProxy.Supervisor]
    
    IO.puts("Starting TgProxy on port #{port}")
    IO.puts("Forwarding requests to #{Application.get_env(:tg_proxy, :target_host, "localhost")}:#{Application.get_env(:tg_proxy, :target_port, 8080)}")
    
    Supervisor.start_link(children, opts)
  end
end