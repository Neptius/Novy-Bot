defmodule NovyBot.FFXIV.Queries.GetCharacter do
  @moduledoc """
  Methods for getting heroes from the OpenDota API.
  """

  alias NovyBot.FFXIV.HttpClient

  @doc """
  Get a player by their lodestone id.

  ## Examples

        iex> GetCharacter.call(20753490)
        {:ok, "Neptius"}

        iex> GetCharacter.call(0)
        {:error, "Player not found"}

  """
  @spec call(lodestone_id :: integer) :: {:ok, String.t()} | {:error, String.t()}
  def call(lodestone_id) do
    # https://lalachievements.com/api/charrealtime/20753490
    case HttpClient.get("/characters/#{lodestone_id}/titles/owned?limit=2") do
      # case HttpClient.get("/titles?limit=2") do
      {:ok, data} ->
        {:ok, data}

      {:error, _} ->
        {:error, "Error fetching player"}
    end
  end
end
