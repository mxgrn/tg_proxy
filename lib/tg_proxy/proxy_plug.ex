defmodule TgProxy.ProxyPlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    target_port = opts[:target_port] || 8080
    target_host = opts[:target_host] || "localhost"
    
    url = build_target_url(target_host, target_port, conn)
    headers = build_headers(conn)
    body = read_request_body(conn)
    
    case forward_request(conn.method, url, body, headers) do
      {:ok, response} ->
        conn
        |> put_resp_headers(response.headers)
        |> send_resp(response.status_code, response.body)
        
      {:error, reason} ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(502, "Bad Gateway: #{inspect(reason)}")
    end
  end
  
  defp build_target_url(host, port, conn) do
    query_string = if conn.query_string != "", do: "?#{conn.query_string}", else: ""
    "http://#{host}:#{port}#{conn.request_path}#{query_string}"
  end
  
  defp build_headers(conn) do
    conn.req_headers
    |> Enum.reject(fn {name, _} -> 
      String.downcase(name) in ["host", "content-length"]
    end)
  end
  
  defp read_request_body(conn) do
    case read_body(conn, []) do
      {:ok, body, _conn} -> body
      {:more, _partial, _conn} -> ""
      {:error, _reason} -> ""
    end
  end
  
  defp forward_request(method, url, body, headers) do
    http_method = method |> String.downcase() |> String.to_atom()
    
    options = [
      recv_timeout: 30_000,
      timeout: 30_000
    ]
    
    case HTTPoison.request(http_method, url, body, headers, options) do
      {:ok, %HTTPoison.Response{} = response} ->
        {:ok, response}
        
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
  
  defp put_resp_headers(conn, headers) do
    Enum.reduce(headers, conn, fn {name, value}, acc ->
      if String.downcase(name) not in ["content-length", "transfer-encoding"] do
        put_resp_header(acc, String.downcase(name), value)
      else
        acc
      end
    end)
  end
end