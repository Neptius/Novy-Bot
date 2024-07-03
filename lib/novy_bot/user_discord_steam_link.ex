defmodule NovyBot.UserDiscordSteamLink do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias NovyBot.Repo
  alias NovyBot.UserDiscordSteamLink

  schema "user_discord_steam_link" do
    field(:discord_guild_id, :integer)
    field(:discord_id, :integer)
    field(:steam_32_id, :integer)
    field(:steam_64_id, :integer)
    field(:token, :string)
    field(:validated_at, :utc_datetime)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(auth, attrs) do
    auth
    |> cast(attrs, [
      :discord_guild_id,
      :discord_id,
      :steam_32_id,
      :steam_64_id,
      :token,
      :validated_at
    ])
    |> validate_required([:discord_guild_id, :discord_id, :steam_32_id, :steam_64_id, :token])
  end

  def create_link(attrs \\ %{}) do
    %UserDiscordSteamLink{}
    |> UserDiscordSteamLink.changeset(attrs)
    |> Repo.insert()
  end

  def update_link(%UserDiscordSteamLink{} = link, attrs) do
    link
    |> UserDiscordSteamLink.changeset(attrs)
    |> Repo.update()
  end

  def upsert_link(attrs \\ %{}) do
    link =
      get_link_by_steam_id_and_guild_id_and_discord_id(
        attrs[:steam_32_id],
        attrs[:steam_64_id],
        attrs[:discord_guild_id],
        attrs[:discord_id]
      )

    case link do
      nil -> create_link(attrs)
      _ -> update_link(link, attrs)
    end
  end

  def get_link_by_steam_id_and_guild_id_and_discord_id(
        steam_32_id,
        steam_64_id,
        discord_guild_id,
        discord_id
      ) do
    Repo.one(
      from(
        l in UserDiscordSteamLink,
        where: l.steam_32_id == ^steam_32_id,
        where: l.steam_64_id == ^steam_64_id,
        where: l.discord_guild_id == ^discord_guild_id,
        where: l.discord_id == ^discord_id
      )
    )
  end

  def get_link_by_guild_id_and_discord_id(discord_guild_id, discord_id) do
    Repo.one(
      from(
        l in UserDiscordSteamLink,
        where: l.discord_guild_id == ^discord_guild_id,
        where: l.discord_id == ^discord_id
      )
    )
  end

  def validate_link(link) do
    link
    |> UserDiscordSteamLink.changeset(%{validated_at: DateTime.utc_now()})
    |> Repo.update()
  end
end
