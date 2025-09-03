defmodule TgProxy.Router do
  use Plug.Router
  
  plug TgProxy.HealthCheck
  plug :match
  plug :dispatch
  
  match _ do
    opts = [
      target_host: Application.get_env(:tg_proxy, :target_host, "localhost"),
      target_port: Application.get_env(:tg_proxy, :target_port, 8080)
    ]
    
    TgProxy.ProxyPlug.call(conn, TgProxy.ProxyPlug.init(opts))
  end
end