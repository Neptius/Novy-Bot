defmodule NovyBot.Dota.Queries.GetPlayer do
  @moduledoc """
  Methods for getting heroes from the OpenDota API.
  """

  alias NovyBot.Dota.GraphqlClient
  alias NovyBot.Cache

  @doc """
  Get a player by their steam account id.

  ## Examples

        iex> GetPlayer.call(135612089)
        {:ok, "Neptius"}

        iex> GetPlayer.call(0)
        {:error, "Player not found"}

  """
  @spec call(steam32Id :: integer) :: {:ok, String.t()} | {:error, String.t()}
  def call(steam32Id) do
    case get_from_cache(steam32Id) do
      {:ok, name} -> {:ok, name}
      :not_found -> fetch_and_cache(steam32Id)
    end
  end

  @spec get_from_cache(steam32Id :: integer) :: {:ok, String.t()} | :not_found
  defp get_from_cache(steam32Id) do
    IO.inspect("Getting player from cache")

    case Cache.get("player:#{steam32Id}") do
      {:ok, nil} -> :not_found
      {:ok, name} -> {:ok, name}
      {:error, _} -> :not_found
    end
  end

  @spec fetch_and_cache(steam32Id :: integer) :: {:ok, String.t()} | {:error, String.t()}
  defp fetch_and_cache(steam32Id) do
    IO.inspect("Fetching player")

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
        Cache.put("player:#{steam32Id}", name, 30)
        {:ok, name}

      {:ok, %{"player" => nil}} ->
        {:error, "Player not found"}

      {:error, _} ->
        {:error, "Error fetching player"}
    end
  end
end
