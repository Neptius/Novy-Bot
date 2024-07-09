defmodule NovyBot.Commands.Dota.Player do
  require Logger

  def name(), do: "player"

  def description(), do: "Répond avec Pong!"

  def type(), do: :slash

  def options(), do: []

  def execute(_interaction) do
    [
      content: "Pong!"
    ]
  end
end
