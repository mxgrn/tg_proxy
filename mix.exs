defmodule TgProxy.MixProject do
  use Mix.Project

  def project do
    [
      app: :tg_proxy,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TgProxy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.6"},
      {:httpoison, "~> 2.2"},
      {:jason, "~> 1.4"}
    ]
  end
end
