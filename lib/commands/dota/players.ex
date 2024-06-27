defmodule NovyBot.Commands.Dota.Players do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias NovyBot.Dota.Api.Mehtods.GetPlayers

  def name(), do: "players"

  @impl true
  def description(), do: "Get the player's name."

  @impl true
  def command(_interaction) do
    {:ok, user} = GetPlayers.call()
    personal_name = user["profile"]["personaname"]
    [content: personal_name]
  end

  @impl true
  def type(), do: :slash
end
