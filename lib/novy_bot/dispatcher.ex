defmodule NovyBot.Dispatcher do
  use GenServer
  require Logger

  alias Nostrum.Struct.Interaction

  # API publique

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_interaction(%Interaction{} = interaction) do
    IO.inspect(interaction)
    GenServer.call(__MODULE__, {:handle_interaction, interaction})
  end

  def create_command(pid, command) do
    GenServer.call(pid, {:create_command, command})
  end

  def update_command(pid, command_name, new_command) do
    GenServer.call(pid, {:update_command, command_name, new_command})
  end

  def delete_command(pid, command_name) do
    GenServer.call(pid, {:delete_command, command_name})
  end

  def list_commands(pid) do
    GenServer.call(pid, :list_commands)
  end

  # Callbacks de GenServer

  def handle_call({:create_command, command}, _from, state) do
    # Logique pour créer une commande via l'API Discord
    {:reply, :ok, Map.put(state, command.name, command)}
  end

  def handle_call({:update_command, command_name, new_command}, _from, state) do
    # Logique pour mettre à jour une commande via l'API Discord
    {:reply, :ok, Map.put(state, command_name, new_command)}
  end

  def handle_call({:delete_command, command_name}, _from, state) do
    # Logique pour supprimer une commande via l'API Discord
    {:reply, :ok, Map.delete(state, command_name)}
  end

  def handle_call(:list_commands, _from, state) do
    # Retourne la liste des commandes
    {:reply, Map.values(state), state}
  end
end
