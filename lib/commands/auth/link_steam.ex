defmodule NovyBot.Commands.Auth.LinkSteam do
  require Logger

  @behaviour Nosedrum.ApplicationCommand

  def name(), do: "link_steam"

  @impl true
  def description(), do: "Lie un compte Steam à ton compte Discord."

  @impl true
  def command(interaction) do
    [%{name: "url_profile_steam", value: url_profile_steam}] = interaction.data.options
    discord_guild_id = interaction.guild_id
    discord_id = interaction.user.id
    username = interaction.user.global_name

    # On vérifie que l'url soit bien https://steamcommunity.com/id/ ou https://steamcommunity.com/profiles/
    if String.starts_with?(url_profile_steam, "https://steamcommunity.com/id/") ||
         String.starts_with?(url_profile_steam, "https://steamcommunity.com/profiles/") do
      # On requête l'url de la page pour récupérer le HTML
      case Req.get(url_profile_steam) do
        {:ok, %Req.Response{body: body}} ->
          {:ok, document} = Floki.parse_document(body)

          # On récupère le steam32id
          steam32id =
            document
            |> Floki.attribute("div.playerAvatar.profile_header_size", "data-miniprofile")
            |> List.first()
            |> Integer.parse()
            |> elem(0)


          # ON génère un uniq id de 32 caractères
          token = :crypto.strong_rand_bytes(32) |> Base.url_encode64()

          # Création du lien entre le compte Discord et le compte Steam
          # NovyBot.UserDiscordSteamLink.create_link(%{
          #   discord_guild_id: discord_guild_id,
          #   discord_id: discord_id,
          #   steam_id: steam32id,
          #   token: token
          # })

          # On envoie un message à l'utilisateur
          [
            content:
              "Hey #{username}, pour lier ton compte Steam, va sur ton profil Steam et ajoute le token suivant à ton résumé: #{token}}",
            ephemeral?: true
          ]

        _ ->
          [
            content: "L'url de ton profil Steam n'est pas valide.",
            ephemeral?: true
          ]
      end
    else
      [
        content: "L'url de ton profil Steam n'est pas valide.",
        ephemeral?: true
      ]
    end
  end

  @impl true
  def options() do
    [
      %{
        type: :string,
        name: "url_profile_steam",
        description: "Url de ton profil Steam.",
        required: false
      }
    ]
  end

  @impl true
  def type(), do: :slash
end
