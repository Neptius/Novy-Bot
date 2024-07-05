defmodule NovyBot.CommandHandler do
  require Logger

  alias NovyBot.Dispatcher

  def load_all_command() do
    get_all_command()
    |> queue_all_commands()

    register_commands()
  end

  defp get_all_command() do
    :code.all_available()
    |> Enum.filter(fn {module, _, _} -> is_command?(module) end)
    |> Enum.map(fn {module_charlist, _, _} -> List.to_existing_atom(module_charlist) end)
  end

  defp is_command?(module_charlist) do
    List.to_string(module_charlist)
    |> String.starts_with?("Elixir.NovyBot.Commands")
  end

  # Filter out any module that doesn't implement the ApplicationCommand behaviour
  # defp filter_application_commands(command_list) do
  #   Enum.filter(command_list, fn command ->
  #     case command.module_info(:attributes)[:behaviour] do
  #       attr when is_list(attr) -> Enum.member?(attr, Nosedrum.ApplicationCommand)

  #       # Skip because module doesn't implement ANY behaviour
  #       nil -> false
  #     end
  #   end)
  # end

  defp queue_all_commands(commands) do
    Enum.each(commands, fn command ->
      Dispatcher.add_command(command.name(), command)
      IO.inspect("Added module #{command} as command /#{command.name()}")
    end)
  end

  defp register_commands() do
    Application.get_env(:novy_bot, :guild_ids)
    |> Enum.each(fn guild_id ->
      case Dispatcher.process_commands(guild_id) do
        {:error, {:error, error}} ->
          IO.inspect(
            "Error processing commands for server #{guild_id}:\n #{inspect(error, pretty: true)}"
          )

        _ ->
          IO.inspect("Successfully registered application commands to #{guild_id}")
      end
    end)
  end
end
