# Onward

`Onward` is an Elixir plug module for proxying paths to another location using a macro. This plug allows you to easily define proxy routes in your Plug or Phoenix applications.

## Installation

Add `httpoison` and `plug_cowboy` to your list of dependencies in `mix.exs`:

```elixir
defp deps do
  [
    {:plug_cowboy, "~> 2.0"},
    {:httpoison, "~> 1.8"}
  ]
end

Then, run mix deps.get to fetch the new dependencies.


## Usage
To use Onward, create a router or plug module and use the proxy macro to define your proxy routes.

```elixir
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
```

In this example, any request to /path will be proxied to http://localhost:4000.
