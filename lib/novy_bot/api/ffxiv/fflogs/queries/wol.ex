defmodule NovyBot.Api.FFXIV.FFlog.Wol do
  @moduledoc """
  Methods for getting heroes from the OpenDota API.
  """

  use Nebulex.Caching

  alias NovyBot.Api.FFXIV.FFlog.Client
  alias NovyBot.Cache


  @doc """
  Get a player by their steam account id.

  ## Examples

        iex> NovyBot.Api.FFXIV.FFlog.Wol.call(12673432)
        {:ok, "Neptius"}

        iex> NovyBot.Api.FFXIV.FFlog.Wol.call(0)
        {:error, "Player not found"}

  """
  @decorate cacheable(cache: Cache, opts: [ttl: :timer.seconds(60)])
  @spec call(fflog_id :: integer) :: {:ok, String.t()} | {:error, String.t()}
  def call(fflog_id) do
    query = """
      query {
        characterData {
          character(id: #{fflog_id}) {
            name
          }
        }
      }
    """

    case Client.post(query) do
      {:ok, %{"characterData" => %{"character" => %{"name" => name}}}} ->
        {:ok, name}

      {:ok, %{"player" => nil}} ->
        {:error, "Player not found"}

      {:error, _} ->
        {:error, "Error fetching player"}
    end
  end
end
