defmodule NovyBot.Dota.Queries.GetPlayers do
  @moduledoc """
  Methods for getting heroes from the OpenDota API.
  """

  alias NovyBot.Dota.GraphqlClient

  @doc """
  Get a player by their steam account id.

  ## Examples

        iex> GetPlayers.call(135612089)
        {:ok, "Neptius"}

        iex> GetPlayers.call(0)
        {:error, "Player not found"}

  """
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
      {:ok, %{"player" => %{"steamAccount" => %{"name" => name }}}} ->
        {:ok, name}
      {:ok, %{"player" => nil}} ->
        {:error, "Player not found"}
      {:error, _} ->
        {:error, "Error fetching player"}
    end
  end
end
