defmodule NovyBot.Extractor.FFXIV.Lodestone do

  @json_character "deps/lodestone_css_selectors/profile/character.json"
  @json_attributes "deps/lodestone_css_selectors/profile/attributes.json"
  @json_gearset "deps/lodestone_css_selectors/profile/gearset.json"


  def parse do

  end

  @doc """
  Get a player by their steam account id.

  ## Examples

        iex> NovyBot.Extractor.FFXIV.Lodestone.get_character(20753490)
        {:ok, "Neptius"}

        iex> NovyBot.Extractor.FFXIV.Lodestone.get_character(0)
        {:error, "Player not found"}

  """
  def get_character(lodestone_id) do
    url = "https://fr.finalfantasyxiv.com/lodestone/character/#{lodestone_id}"




  end


  def get_css_selectors do
    {:ok, json_character} = get_json(@json_character)
    {:ok, json_attributes} = get_json(@json_attributes)
    {:ok, json_gearset} = get_json(@json_gearset)

    # MERGE JSON
    Map.new()
    |> Map.merge(json_character)
    |> Map.merge(json_attributes)
    |> Map.merge(json_gearset)
  end


  defp get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body), do: {:ok, json}
  end
end
