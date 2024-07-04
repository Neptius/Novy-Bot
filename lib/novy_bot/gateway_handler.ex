defmodule NovyBot.GatewayHandler do
  use Nostrum.Consumer
  require Logger

  alias NovyBot.Gateway.Events.{}
  alias NovyBot.Dispatcher


  # MessageCreate
  @spec handle_event(Nostrum.Consumer.event()) :: any()
  # def handle_event({:MESSAGE_CREATE, msg, _ws_state}), do: MessageCreate.handle(msg)
  def handle_event({:INTERACTION_CREATE, interaction, _}), do: Dispatcher.handle_interaction(interaction)
  def handle_event(_), do: :noop
end
