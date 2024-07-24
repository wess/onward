defmodule Onward.MixProject do
  use Mix.Project

  @source_url "https://github.com/wess/onward"
  @description "A Plug to proxy requests to another location"
  @version "0.0.1"

  def project do
    [
      app: :onward,
      description: @description,
      version: @version,
      package: package(),
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Wess Cope"],
      links: %{"Github" => @source_url}
    }
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.7.1"},
      {:httpoison, "~> 2.2.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
    ]
  end
end
