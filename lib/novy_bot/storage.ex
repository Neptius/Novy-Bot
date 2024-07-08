defmodule NovyBot.Storage do
  # TODO: IMPLEMENTER LA GESTION DES TYPES DE CALLBACKS
  @callback_type_map %{
    pong: 1,
    channel_message_with_source: 4,
    deferred_channel_message_with_source: 5,
    deferred_update_message: 6,
    update_message: 7,
    application_command_autocomplete_result: 8,
    modal: 9
  }

  @flag_map %{
    ephemeral: 64
  }

  # https://discord.com/developers/docs/interactions/receiving-and-responding#responding-to-an-interaction

  def respond(interaction, command_response) do
    type =
      command_response
      |> Keyword.get(:type, :channel_message_with_source)
      |> convert_callback_type()

    data =
      command_response
      |> Keyword.take([
        :tts,
        :content,
        :embeds,
        :allowed_mentions,
        # :flags,
        :components,
        :attachements,
        :poll
      ])
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
