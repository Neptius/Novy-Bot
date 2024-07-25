defmodule NovyBot.Api.FFXIV.Tomestone.Wol do
  @moduledoc """
  Methods for getting heroes from the OpenDota API.
  """

  use Nebulex.Caching

  alias NovyBot.Api.FFXIV.Tomestone.Client
  alias NovyBot.Cache


  @doc """
  Get a player by their steam account id.

  ## Examples

        iex> NovyBot.Api.FFXIV.Tomestone.Wol.call(20753490)
        {:ok, "Neptius"}

        iex> NovyBot.Api.FFXIV.Tomestone.Wol.call(0)
        {:error, "Player not found"}

  """
  @decorate cacheable(cache: Cache, opts: [ttl: :timer.seconds(60)])
  @spec call(lodestone_id :: integer) :: {:ok, String.t()} | {:error, String.t()}
  def call(lodestone_id) do
    case Client.get("/character/profile/#{lodestone_id}") do
      {:ok, data} ->
        {:ok, data}

      {:error, message} ->
        {:error, message}
    end
  end
end
