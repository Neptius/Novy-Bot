defmodule NovyBot.Dota.Api.Mehtods.GetPlayersMatches do
  @moduledoc """
  Methods for getting heroes from the OpenDota API.
  """

  alias NovyBot.Dota.Api.HttpClient

  def call() do
    HttpClient.get("players/135612089/matches?limit=5")
  end
end
