defmodule NovyBot.Dota.Api.GraphqlClient do
  @moduledoc """
  Client for the OpenDota API.
  """

  use AbsintheClient, url: "https://api.stratz.com/graphql/" # Remplace par ton endpoint GraphQL

  def headers do
    [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTdWJqZWN0IjoiMjA4NTdlNzEtYjRiZS00OWYwLWJlYTEtMGVkNGMyZDZiNDYzIiwiU3RlYW1JZCI6IjEzNTYxMjA4OSIsIm5iZiI6MTcxOTUwODk0NSwiZXhwIjoxNzUxMDQ0OTQ1LCJpYXQiOjE3MTk1MDg5NDUsImlzcyI6Imh0dHBzOi8vYXBpLnN0cmF0ei5jb20ifQ.s-LXndzrrooLuacYgxCSxgWe2aEUpmjK6Et3RJB4HZk"} # Si nécessaire
    ]
  end
end
