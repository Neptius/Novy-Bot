defmodule NovyBot.Commands.Auth.ValidSteam do
  require Logger

  alias NovyBot.UserDiscordSteamLink

  @behaviour Nosedrum.ApplicationCommand

  def name(), do: "valid_steam"

  @impl true
  def description(), do: "Valide ton compte Steam."

  @impl true
  def command(interaction) do
    [%{name: "token", value: token}] = interaction.data.options
    discord_guild_id = interaction.guild_id
    discord_id = interaction.user.id

    # On vérifie que le token est bien présent dans la base de données
    case UserDiscordSteamLink.get_link_by_token_and_guild_and_discord_id(token, discord_guild_id, discord_id) do
      %UserDiscordSteamLink{} = link ->
        # On met à jour le lien pour le valider
        # UserDiscordSteamLink.validate_link(link)
        [
          content: "Ton compte Steam a bien été validé.",
          ephemeral?: true
        ]
      nil ->
        [
          content: "Le token n'est pas valide.",
          ephemeral?: true
        ]
    end
  end

  @impl true
  def options() do
    [
      %{
        type: :string,
        name: "token",
        description: "Token de validation présent sur ton profil Steam.",
        required: true
      }
    ]
  end

  @impl true
  def type(), do: :slash
end
