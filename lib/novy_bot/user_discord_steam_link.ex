defmodule NovyBot.UserDiscordSteamLink do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias NovyBot.Repo
  alias NovyBot.UserDiscordSteamLink

  schema "user_discord_steam_link" do
    field(:discord_guild_id, :integer)
    field(:discord_id, :integer)
    field(:steam_id, :integer)
    field(:token, :string)
    field(:validated_at, :utc_datetime)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(auth, attrs) do
    auth
    |> cast(attrs, [:discord_guild_id, :discord_id, :steam_id, :token, :validated_at])
    |> validate_required([:discord_guild_id, :discord_id, :steam_id, :token])
  end

  def create_link(attrs \\ %{}) do
    %UserDiscordSteamLink{}
    |> UserDiscordSteamLink.changeset(attrs)
    |> Repo.insert()
  end

  def validate_link(link) do
    %UserDiscordSteamLink{}
    |> UserDiscordSteamLink.changeset(%{validated_at: DateTime.utc_now()})
    |> Repo.update()
  end

  def get_link_by_token_and_guild_and_discord_id(token, discord_guild_id, discord_id) do
    Repo.one(
      from(u in UserDiscordSteamLink,
        where:
          u.token == ^token and u.discord_guild_id == ^discord_guild_id and
            u.discord_id == ^discord_id
      )
    )
  end
end
