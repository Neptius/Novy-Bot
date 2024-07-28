defmodule NovyBot.Extractor.FFXIV.Lodestone.Character do
  @json_character "deps/lodestone_css_selectors/profile/character.json"
  @json_attributes "deps/lodestone_css_selectors/profile/attributes.json"
  @json_gearset "deps/lodestone_css_selectors/profile/gearset.json"

  @doc """
  Get a player by their steam account id.

  ## Examples

        iex> NovyBot.Extractor.FFXIV.Lodestone.Character.execute(20753490)
        {:ok, "Neptius"}

        iex> NovyBot.Extractor.FFXIV.Lodestone.Character.execute(0)
        {:error, "Player not found"}

  """
  def execute(lodestone_id) do
    document = fetch_data(lodestone_id) |> parse_html()
    selectors = get_css_selectors()
    columns = handle_columns(selectors)
    parsed = extract_data(document, selectors, columns)
    chacacter_data = %{
      "Character" => Map.put(parsed, "LodestoneId", lodestone_id)
    }

    chacacter_data
    |> export_to_json()
  end

  defp fetch_data(lodestone_id) do
    case Req.get("https://fr.finalfantasyxiv.com/lodestone/character/#{lodestone_id}") do
      {:ok, %Req.Response{body: body}} -> body
      {:error, response} -> raise response
    end
  end

  defp parse_html(html) do
    {:ok, document} = Floki.parse_document(html)
    document
  end

  defp handle_columns(selectors) do
    selectors
    |> Map.keys()
    |> Enum.map(&definition_name_to_column_name(&1))
  end

  defp extract_data(document, selectors, columns) do
    Enum.reduce(columns, %{}, fn column, acc ->
      IO.inspect("--------#{column}--------")
      definition = get_definition(selectors, column)

      case column do
        "Root" ->
          IO.inspect("Root")
          parsed = handle_column(definition, document)
          context = parsed.data
          contextDOM = parse_html(context)

        _ ->
          parsed = handle_column(definition, document)

          case parsed do
            %{is_patch: true} ->
              Map.merge(acc, parsed.data)
            nil ->
              acc
            _ ->
              Map.put(acc, column, parsed.data)
          end
      end
    end)
  end

  defp get_definition(selectors, name) do
    Map.get(selectors, String.upcase(name)) ||
      Map.get(selectors, name |> Macro.underscore() |> String.upcase())
  end

  defp handle_column(definition, document) do
    case definition do
      %{"selector" => selector} ->
        IO.inspect("Definition is a definition")
        element = Floki.find(document, selector)
        data = handle_element(element, definition)

        %{is_patch: is_map(data), data: data}

      %{"ROOT" => ROOT} ->
        IO.inspect("Definition is a root")

        nil

      _ ->
        IO.inspect("Definition is a registry")

        data =
          Enum.reduce(Map.keys(definition), %{}, fn key, acc ->
            deep_definition = get_definition(definition, key)
            parsed = handle_column(deep_definition, document)

            case parsed do
              %{data: _data} ->
                case parsed do
                  %{is_patch: true} ->
                    Map.merge(acc, parsed.data)

                  nil ->
                    acc

                  _ ->
                    Map.put(acc, definition_name_to_column_name(key), parsed.data)
                end

              _ ->
                acc
            end
          end)

        %{is_patch: false, data: data}
    end
  end

  defp handle_element(element, definition) do
    case element do
      [] ->
        nil

      _ ->
        res =
          case definition do
            %{"attribute" => attribute} ->
              Floki.attribute(element, attribute)

            _ ->
              Floki.text(element)
          end

        # case definition do
        #   %{"regex" => regex} ->
        #     Floki.text(element)
        #     |> String.replace(~r/[^[:alnum:]]/, "")
        #     |> String.match?(~r/#{regex}/)
        #   _ ->
        #     nil
        # end

        res
    end
  end

  defp definition_name_to_column_name(key) do
    key
    |> String.split("_")
    |> Enum.map(&String.capitalize(&1))
    |> Enum.join("")
    |> String.replace(~r/Id/, "ID")
  end

  def get_css_selectors do
    {:ok, json_character} = get_json(@json_character)
    {:ok, json_attributes} = get_json(@json_attributes)
    {:ok, json_gearset} = get_json(@json_gearset)

    Map.new()
    |> Map.merge(json_character)
    |> Map.merge(json_attributes)
    |> Map.merge(json_gearset)
  end

  defp get_json(filename) do
    with {:ok, body} <- File.read(filename), {:ok, json} <- Jason.decode(body), do: {:ok, json}
  end

  def export_to_json(data) do
    case Jason.encode(data) do
      {:ok, json} ->
        File.write!("output.json", json)
      {:error, reason} ->
        IO.puts("Erreur lors de l'encodage JSON: #{reason}")
    end
  end
end
