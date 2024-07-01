defmodule NovyBot.Dota.Api.GraphqlClient do
  @moduledoc """
  Client for the OpenDota API.
  """

  use AbsintheClient, url: "https://api.stratz.com/graphql/" # Remplace par ton endpoint GraphQL

  def headers do
    [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer "} # Si nécessaire
    ]
  end
end
