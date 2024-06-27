defmodule NovyBot.Gateway.Handler do
  use Nostrum.Consumer
  require Logger

  alias NovyBot.Gateway.Events.{}
  # MessageCreate
  @spec handle_event(Nostrum.Consumer.event()) :: any()
  # def handle_event({:MESSAGE_CREATE, msg, _ws_state}), do: MessageCreate.handle(msg)
  def handle_event(_), do: :noop
end
