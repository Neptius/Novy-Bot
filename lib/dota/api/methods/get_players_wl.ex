defmodule NovyBot.Dota.Api.Mehtods.GetPlayersWL do
  @moduledoc """
  Methods for getting heroes from the OpenDota API.
  """

  alias NovyBot.Dota.Api.HttpClient

  defmodule WinLoss do
    @moduledoc """
    Structure representing a player's win/loss record.
    """
    defstruct [:win, :lose]
  end

  @doc """
  Get player's win/loss record.

  ## Examples

      iex> GetPlayersWL.call()
      {:ok, %GetPlayersWL.WinLoss{win: 300, lose: 200}}

      iex> GetPlayersWL.call()
      {:error, "Error message"}
  """
  @spec call(steam32_account_id :: integer) :: {:ok, WinLoss.t()} | {:error, String.t()}
  def call(steam32_account_id) do
    case HttpClient.get("players/#{steam32_account_id}/wl") do
      {:ok, %{"win" => win, "lose" => lose}} ->
        {:ok, %WinLoss{win: win, lose: lose}}

      {:error, _} = error ->
        error
    end
  end
end
