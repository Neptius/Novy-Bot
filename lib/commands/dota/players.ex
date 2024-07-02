defmodule NovyBot.Commands.Dota.Players do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias NovyBot.Dota.Queries.GetPlayers

  def name(), do: "playername"

  @impl true
  def description(), do: "Get the player's name."

  @impl true
  def command(_interaction) do
    case GetPlayers.call(135612089) do
      {:ok, name} ->
        [content: name]
      {:error, _} ->
        [content: "Player not found"]
    end
  end

  @impl true
  def type(), do: :slash
end
