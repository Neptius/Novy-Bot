defmodule NovyBot.Commands.Auth.LinkSteam do
  require Logger

  @behaviour Nosedrum.ApplicationCommand

  def name(), do: "link_steam"

  @impl true
  def description(), do: "Lie un compte Steam à ton compte Discord."

  @impl true
  def type(), do: :slash

  @impl true
  def command(interaction) do
    [%{name: "url_profile_steam", value: url_profile_steam}] = interaction.data.options

    discord_guild_id = interaction.guild_id
    discord_id = interaction.user.id
    username = interaction.user.global_name

    if valid_steam_url?(url_profile_steam) do
      with {:ok, %Req.Response{body: body}} <- Req.get(url_profile_steam),
           {:ok, document} <- Floki.parse_document(body),
           steam_32_id <- get_steam_32_id(document),
           steam_64_id = steam_32_id + 76_561_197_960_265_728,
           token = generate_token() do

        upsert_steam_link(discord_guild_id, discord_id, steam_32_id, steam_64_id, token)

        [
          content:
            "Hey #{username}, pour lier ton compte Steam, va sur ton profil Steam et ajoute le token suivant à ton résumé: #{token}",
          ephemeral?: true
        ]
      else
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

  defp valid_steam_url?(url) do
    String.starts_with?(url, "https://steamcommunity.com/id/") ||
      String.starts_with?(url, "https://steamcommunity.com/profiles/")
  end

  defp get_steam_32_id(document) do
    document
    |> Floki.attribute("div.playerAvatar.profile_header_size", "data-miniprofile")
    |> List.first()
    |> Integer.parse()
    |> elem(0)
  end

  defp generate_token do
    :crypto.strong_rand_bytes(32) |> Base.url_encode64()
  end

  defp upsert_steam_link(discord_guild_id, discord_id, steam_32_id, steam_64_id, token) do
    NovyBot.UserDiscordSteamLink.upsert_link(%{
      discord_guild_id: discord_guild_id,
      discord_id: discord_id,
      steam_32_id: steam_32_id,
      steam_64_id: steam_64_id,
      token: token,
      validated_at: nil
    })
  end

  @impl true
  def options() do
    [
      %{
        type: :string,
        name: "url_profile_steam",
        description: "Url de ton profil Steam.",
        required: true
      }
    ]
  end
end
