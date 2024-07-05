defmodule NovyBot.Commands.Ping do
  @moduledoc """
  Module pour la commande Ping.
  """

  require Logger

  def name(), do: "ping"

  def description(), do: "Répond avec Pong!"

  def type(), do: :slash

  def options(), do: []

  def execute(_interaction) do
    [
      content: "Pong!",
      type: :pong
    ]
  end
end
