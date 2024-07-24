defmodule Onward.MixProject do
  use Mix.Project

  def project do
    [
      app: :onward,
      version: "0.0.1",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
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
    ]
  end
end
