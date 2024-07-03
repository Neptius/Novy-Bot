defmodule NovyBot.Commands.Dota.Player do
  require Logger

  @behaviour Nosedrum.ApplicationCommand

  alias NovyBot.UserDiscordSteamLink
  alias NovyBot.Dota.Queries.GetPlayer

  def name(), do: "playername"

  @impl true
  def description(), do: "Get the player's name."

  @impl true
  def command(interaction) do
    discord_guild_id = interaction.guild_id
    discord_id = interaction.user.id

    case UserDiscordSteamLink.get_valid_link_by_guild_id_and_discord_id(
           discord_guild_id,
           discord_id
         ) do
      nil ->
        [
          content: "You need to link your Steam account first.",
          ephemeral?: true
        ]

      link ->
        steam32id = link.steam_32_id

        case GetPlayer.call(steam32id) do
          {:ok, name} ->
            [content: name]

          {:error, _} ->
            [content: "Player not found"]
        end
    end
  end

  @impl true
  def type(), do: :slash
end
