defmodule NovyBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :novy_bot,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {NovyBot.Core.Main, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Discord interfacing
      {:nostrum, github: "Kraigie/nostrum", override: true},
      {:nosedrum, github: "jchristgit/nosedrum", override: true},
      # HTTP client
      {:absinthe_client, "~> 0.1.0"},
      # DOM
      {:floki, "~> 0.36.0"},
      # Database
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  defp aliases do
    []
  end
end
