defmodule NovyBot.Dispatcher do
  require Logger

  use GenServer

  alias Nostrum.Struct.Interaction
  alias NovyBot.Storage

  @option_type_map %{
    sub_command: 1,
    sub_command_group: 2,
    string: 3,
    integer: 4,
    boolean: 5,
    user: 6,
    channel: 7,
    role: 8,
    mentionable: 9,
    number: 10
  }

  @command_type_map %{
    slash: 1,
    user: 2,
    message: 3
  }

  # API publique

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: Keyword.get(opts, :name, __MODULE__))
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def add_command(command_name, command, pid \\ __MODULE__) do
    GenServer.call(pid, {:add_command, command_name, command})
  end

  def process_commands(guild_id, pid \\ __MODULE__) do
    GenServer.call(pid, {:process_commands, guild_id})
  end

  def handle_interaction(%Interaction{} = interaction, pid \\ __MODULE__) do
    case GenServer.call(pid, {:handle_interaction, interaction}) do
      {:ok, command} ->
        command_response = command.execute(interaction)
        Storage.respond(interaction, command_response)

      {:error, error} ->
        IO.inspect("Error handling interaction: #{inspect(error)}")
    end
  end

  # Callbacks de GenServer

  def handle_call({:add_command, command_name, command}, _from, commands) do
    {:reply, :ok, Map.put(commands, command_name, command)}
  end

  def handle_call({:process_commands, guild_id}, _from, commands) do
    IO.inspect("Processing commands for guild #{guild_id}")

    command_list =
      Enum.map(commands, fn {name, command} ->
        build_command_payload(name, command)
      end)

    case Nostrum.Api.bulk_overwrite_guild_application_commands(guild_id, command_list) do
      {:ok, _} = response ->
        {:reply, response, commands}

      error ->
        {:reply, {:error, error}, commands}
    end
  end

  def handle_call({:handle_interaction, %Interaction{data: %{name: name}}}, _from, commands) do
    {:reply, Map.fetch(commands, name), commands}
  end

  # REST

  defp build_command_payload(name, command) do
    Code.ensure_loaded(command)

    options =
      if function_exported?(command, :options, 0) do
        command.options()
        |> parse_option_types()
      else
        []
      end

    %{
      type: parse_type(command.type()),
      name: name
    }
    |> put_type_specific_fields(command, options)
  end

  defp put_type_specific_fields(payload, command, options) do
    if command.type() == :slash do
      payload
      |> Map.put(:description, command.description())
      |> Map.put(:options, options)
    else
      payload
    end
  end

  defp parse_type(type) do
    Map.fetch!(@command_type_map, type)
  end

  defp parse_option_types(options) do
    Enum.map(options, fn
      map when is_map_key(map, :type) ->
        updated_map = Map.update!(map, :type, &Map.fetch!(@option_type_map, &1))

        if is_map_key(updated_map, :options) do
          parsed_options = parse_option_types(updated_map[:options])
          Map.replace!(updated_map, :options, parsed_options)
        else
          updated_map
        end

      map ->
        map
    end)
  end
end
