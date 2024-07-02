defmodule NovyBot.Commands.Dota.Player do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias NovyBot.Dota.Queries.GetPlayer

  def name(), do: "playername"

  @impl true
  def description(), do: "Get the player's name."

  @impl true
  def command(interaction) do
    [%{name: "steam32id", value: steam32id}] = interaction.data.options

    case GetPlayer.call(steam32id) do
      {:ok, name} ->
        [content: name]
      {:error, _} ->
        [content: "Player not found"]
    end
  end

  @impl true
  def options() do
    [
      %{
        type: :string,
        name: "steam32id",
        description: "DERP",
        required: true
      }
    ]
  end

  @impl true
  def type(), do: :slash
end
