defmodule NovyBot.Dota.Api.Mehtods.GetPlayers do
  @moduledoc """
  Methods for getting heroes from the OpenDota API.
  """

  alias NovyBot.Dota.Api.HttpClient

  def call() do
    HttpClient.get("players/135612089")
  end
end
