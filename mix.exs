defmodule Weatherapp.MixProject do
  use Mix.Project

  def project do
    [
      app: :weatherapp,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Weatherapp.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.1"},
      {:poison, "~> 4.0"},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
    ]
  end
end
