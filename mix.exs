defmodule NovyBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :novy_bot,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
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
      {:req, "~> 0.5.0"},
      {:absinthe_client, "~> 0.1.0"}
    ]
  end
end
