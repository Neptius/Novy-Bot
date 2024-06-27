defmodule NovyBot.Dota.Api.Mehtods.GetHeroes do
  @moduledoc """
  Methods for getting heroes from the OpenDota API.
  """

  alias NovyBot.Dota.Api.HttpClient

  def call() do
    HttpClient.get("heroes")
  end
end
