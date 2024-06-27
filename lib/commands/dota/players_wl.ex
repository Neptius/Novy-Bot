defmodule NovyBot.Commands.Dota.PlayersWL do
  require Logger
  @behaviour Nosedrum.ApplicationCommand

  alias NovyBot.Dota.Api.Mehtods.GetPlayersWL

  def name(), do: "players_wl"

  @impl true
  def description(), do: "Get the player's WL."

  @impl true
  def command(interaction) do
    [%{name: "steam32_account_id", value: steam32_account_id}] = interaction.data.options

    {:ok, win_loss} = GetPlayersWL.call(steam32_account_id)

    [
      content: "Win: #{win_loss.win}, Lose: #{win_loss.lose}"
    ]
  end

  @impl true
  def type(), do: :slash

  @impl true
  def options() do
    [
      %{
        type: :string,
        name: "steam32_account_id",
        description: "DERP",
        required: true
      }
    ]
  end
end
