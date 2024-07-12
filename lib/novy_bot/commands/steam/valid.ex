defmodule NovyBot.Commands.Steam.Valid do
  require Logger

  alias NovyBot.UserDiscordSteamLink

  def name(), do: "valid_steam"

  def description(), do: "Valide ton compte Steam."

  def type(), do: :slash

  def command(interaction) do
    discord_guild_id = interaction.guild_id
    discord_id = interaction.user.id
    username = interaction.user.global_name

    # Vérifier la présence du lien dans la base de données
    with %UserDiscordSteamLink{} = link <-
           UserDiscordSteamLink.get_link_by_guild_id_and_discord_id(discord_guild_id, discord_id),
         {:ok, %Req.Response{body: body}} <-
           Req.get("https://steamcommunity.com/profiles/#{link.steam_64_id}"),
         {:ok, document} <- Floki.parse_document(body) do
      token = document |> Floki.find("div.profile_summary") |> Floki.text() |> String.trim()

      IO.inspect(token)
      IO.inspect(link.token)

      if token == link.token do
        UserDiscordSteamLink.validate_link(link)

        [
          content: "Ton compte Steam a bien été validé #{username}.",
          ephemeral?: true
        ]
      else
        [
          content: "Le token n'est pas valide.",
          ephemeral?: true
        ]
      end
    else
      _ ->
        [
          content: "Le token n'est pas valide ou l'URL de ton profil Steam n'est pas valide.",
          ephemeral?: true
        ]
    end
  end
end
