defmodule WebsocketGateway.MixProject do
  use Mix.Project

  def project do
    [
      app: :websocket_gateway,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {WebsocketGateway.Application, []},
      extra_applications: [:logger, :mongodb]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.4"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:mongodb, github: "elixir-mongo/mongodb"},
      {:httpoison, "~> 1.8"},
    ]
  end
end
