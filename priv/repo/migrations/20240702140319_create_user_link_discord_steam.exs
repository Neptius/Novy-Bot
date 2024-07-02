defmodule NovyBot.Repo.Migrations.CreateUserDiscordSteamLink do
  use Ecto.Migration

  def change do
    create table(:user_discord_steam_link) do
      add :discord_guild_id, :bigint
      add :discord_id, :bigint
      add :steam_id, :bigint
      add :token, :string
      add :validated_at, :utc_datetime

      timestamps()
    end
  end
end
