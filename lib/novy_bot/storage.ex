defmodule NovyBot.Storage do
  @callback_type_map %{
    pong: 1,
    channel_message_with_source: 4,
    deferred_channel_message_with_source: 5,
    deferred_update_message: 6,
    update_message: 7
  }

  @flag_map %{
    ephemeral?: 64
  }

  def respond(interaction, command_response) do
    IO.inspect(command_response)
    type =
      command_response
      |> Keyword.get(:type, :channel_message_with_source)
      |> convert_callback_type()

    data =
      command_response
      |> Keyword.take([:content, :embeds, :components, :tts?, :allowed_mentions])
      |> Map.new()
      |> put_flags(command_response)

    res = %{
      type: type,
      data: data
    }

    Nostrum.Api.create_interaction_response(interaction, res)
  end

  defp convert_callback_type(type) do
    Map.get(@callback_type_map, type)
  end

  defp put_flags(data_map, command_response) do
    Enum.reduce(@flag_map, data_map, fn {flag, value}, data_map_acc ->
      if command_response[flag] do
        Map.put(data_map_acc, :flags, value)
      else
        data_map_acc
      end
    end)
  end
end
