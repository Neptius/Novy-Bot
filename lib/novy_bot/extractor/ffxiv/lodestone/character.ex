defmodule NovyBot.Extractor.FFXIV.Lodestone.Character do
  @json_character "deps/lodestone_css_selectors/profile/character.json"
  @json_attributes "deps/lodestone_css_selectors/profile/attributes.json"
  @json_gearset "deps/lodestone_css_selectors/profile/gearset.json"

  @doc """
  Get a player by their Lodestone ID.

  ## Examples

      iex> NovyBot.Extractor.FFXIV.Lodestone.Character.execute(20753490)
      {:ok, "Neptius"}

      iex> NovyBot.Extractor.FFXIV.Lodestone.Character.execute(0)
      {:error, "Player not found"}
  """
  def execute(lodestone_id) do
    with {:ok, document} <- fetch_data(lodestone_id) |> parse_html(),
         selectors <- get_css_selectors(),
         columns <- handle_columns(selectors),
         parsed <- extract_data(document, selectors, columns) do
      character_data = %{"Character" => Map.put(parsed, "LodestoneId", lodestone_id)}
      export_to_json(character_data)
    end
  end

  defp fetch_data(lodestone_id) do
    url = "https://fr.finalfantasyxiv.com/lodestone/character/#{lodestone_id}"

    case Req.get(url) do
      {:ok, %Req.Response{body: body}} -> {:ok, body}
      {:error, _response} = error -> error
    end
  end

  defp parse_html({:ok, html}) do
    Floki.parse_document(html)
  end

  defp parse_html({:error, _} = error), do: error

  defp handle_columns(selectors) do
    Map.keys(selectors)
    |> Enum.map(&definition_name_to_column_name/1)
  end

  defp extract_data(document, selectors, columns) do
    Enum.reduce(columns, %{}, fn column, acc ->
      definition = get_definition(selectors, column)

      case handle_column(definition, document) do
        %{is_patch: true, data: data} -> Map.merge(acc, data)
        %{data: data} -> Map.put(acc, column, data)
        _ -> acc
      end
    end)
  end

  defp get_definition(selectors, name) do
    selectors
    |> Map.get(String.upcase(name), Map.get(selectors, name |> Macro.underscore() |> String.upcase()))
  end

  defp handle_column(%{"selector" => selector} = definition, document) do
    element = Floki.find(document, selector)
    data = handle_element(element, definition)
    %{is_patch: is_map(data), data: data}
  end

  defp handle_column(%{"ROOT" => _root}, _document), do: %{is_patch: false, data: nil}

  defp handle_column(definition, document) when is_map(definition) do
    data = Enum.reduce(definition, %{}, fn {key, deep_definition}, acc ->
      case handle_column(deep_definition, document) do
        %{is_patch: true, data: data} -> Map.merge(acc, data)
        %{data: data} -> Map.put(acc, definition_name_to_column_name(key), data)
        _ -> acc
      end
    end)

    %{is_patch: false, data: data}
  end

  defp handle_element([], _definition), do: nil

  defp handle_element(element, %{"attribute" => attribute}) do
    Floki.attribute(element, attribute)
  end

  defp handle_element(element, _definition) do
    Floki.text(element)
  end

  defp definition_name_to_column_name(key) do
    key
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join("")
    |> String.replace("Id", "ID")
  end

  def get_css_selectors do
    with {:ok, json_character} <- get_json(@json_character),
         {:ok, json_attributes} <- get_json(@json_attributes),
         {:ok, json_gearset} <- get_json(@json_gearset) do
      Map.merge(json_character, json_attributes)
      |> Map.merge(json_gearset)
    else
      _ -> %{}
    end
  end

  defp get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body) do
      {:ok, json}
    else
      _ -> {:error, :invalid_json}
    end
  end

  defp export_to_json(data) do
    case Jason.encode(data) do
      {:ok, json} -> File.write!("character.json", json)
      {:error, reason} -> IO.puts("Erreur lors de l'encodage JSON: #{reason}")
    end
  end
end
