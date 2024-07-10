defmodule NovyBot.Api.Dota.Stratz.GetPlayer do
  @moduledoc """
  Methods for getting heroes from the OpenDota API.
  """

  use Nebulex.Caching

  alias NovyBot.Api.Dota.Stratz.GraphqlClient
  alias NovyBot.Cache


  @doc """
  Get a player by their steam account id.

  ## Examples

        iex> NovyBot.Api.Dota.Stratz.GetPlayer.call(135612089)
        {:ok, "Neptius"}

        iex> NovyBot.Api.Dota.Stratz.GetPlayer.call(0)
        {:error, "Player not found"}

  """
  @decorate cacheable(cache: Cache, opts: [ttl: :timer.seconds(60)])
  @spec call(steam32Id :: integer) :: {:ok, String.t()} | {:error, String.t()}
  def call(steam32Id) do
    query = """
      query {
        player(steamAccountId: #{steam32Id}) {
          steamAccount {
            name
          }
        }
      }
    """

    case GraphqlClient.post(query) do
      {:ok, %{"player" => %{"steamAccount" => %{"name" => name}}}} ->
        {:ok, name}

      {:ok, %{"player" => nil}} ->
        {:error, "Player not found"}

      {:error, _} ->
        {:error, "Error fetching player"}
    end
  end
end
