defmodule NovyBot.Commands.Dota.Player do
  require Logger

  alias NovyBot.UserDiscordSteamLink
  alias NovyBot.Api.Dota.Stratz.GetPlayer

  def name(), do: "player"

  def description(), do: "Répond avec Pong!"

  def type(), do: :slash

  def options(), do: []

  def execute(interaction) do
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
end
