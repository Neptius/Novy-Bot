defmodule NovyBot.Extractor.FFXIV.Lodestone do

  alias NovyBot.Extractor.FFXIV.Lodestone.Character


  @doc """
  Get a player by their Lodestone ID.

  ## Examples

      iex> NovyBot.Extractor.FFXIV.Lodestone.get_character(20753490)
      {:ok, "Neptius"}

      iex> NovyBot.Extractor.FFXIV.Lodestone.get_character(0)
      {:error, "Player not found"}
  """
  def get_character(lodestone_id) do
    Character.execute(lodestone_id)
  end
end
