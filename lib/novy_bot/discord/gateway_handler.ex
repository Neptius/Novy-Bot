defmodule NovyBot.GatewayHandler do
  require Logger

  use Nostrum.Consumer

  alias NovyBot.Dispatcher
  alias NovyBot.CommandHandler

  def handle_event({:READY, _event, _ws_state}), do: CommandHandler.load_all_command()

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}),
    do: Dispatcher.handle_interaction(interaction)

  def handle_event(_), do: :noop
end
