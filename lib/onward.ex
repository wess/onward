defmodule Onward do
  @moduledoc """
  A plug module for proxying paths to another location using a macro.

  ## Example Usage

      defmodule MyRouter do
        use Plug.Router
        use Onward

        plug :match
        plug :dispatch

        proxy "/path", to: "http://localhost:4000"

        match _ do
          send_resp(conn, 404, "Not Found")
        end
      end

  """

  use Plug.Builder

  require Logger

  @doc """
  Defines a proxy route that forwards requests from the specified path to the given destination.

  ## Parameters

    - `path`: The path to proxy from.
    - `opts`: Keyword list of options. Expected key is `:to` with the destination URL.

  ## Example

      proxy "/path", to: "http://localhost:4000"

  """
  defmacro proxy(path, opts) do
    quote do
      plug unquote(__MODULE__), unquote(path), unquote(opts)
    end
  end

  @doc false
  def init(opts) do
    {path, proxy_to} = opts
    %{path: path, proxy_to: proxy_to}
  end

  @doc false
  def call(%Plug.Conn{request_path: request_path} = conn, %{path: path, proxy_to: proxy_to}) do
    if String.starts_with?(request_path, path) do
      proxy_path = String.replace_prefix(request_path, path, "")
      proxy_url = URI.merge(proxy_to, proxy_path) |> to_string()

      Logger.info("Proxying request to: #{proxy_url}")

      case HTTPoison.request(conn.method, proxy_url, conn.body_params, headers(conn), [hackney: [pool: :default]]) do
        {:ok, %HTTPoison.Response{status_code: status, headers: resp_headers, body: body}} ->
          conn
          |> put_resp_headers(resp_headers)
          |> send_resp(status, body)
          |> halt()

        {:error, %HTTPoison.Error{reason: reason}} ->
          Logger.error("Failed to proxy request: #{reason}")
          send_resp(conn, 502, "Bad Gateway")
      end
    else
      conn
    end
  end

  @doc false
  defp headers(conn) do
    conn.req_headers
    |> Enum.into([], fn {key, value} -> {String.to_atom(key), value} end)
  end

  @doc false
  defp put_resp_headers(conn, headers) do
    Enum.reduce(headers, conn, fn {key, value}, acc ->
      put_resp_header(acc, key, value)
    end)
  end
end
