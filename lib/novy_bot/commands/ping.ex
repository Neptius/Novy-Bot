defmodule NovyBot.Commands.Ping do
  @moduledoc """
  Module pour la commande Ping.
  """
  require Logger

  @behaviour NovyBot.Command

  def name(), do: "ping"

  def description(), do: "Répond avec Pong!"

  def type(), do: :slash

  def options(), do: []

  def execute(_interaction) do
    [
      content: "Pong!",
      ephemeral: true
    ]
  end
end
