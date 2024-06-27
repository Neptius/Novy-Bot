defmodule NovyBot.Gateway.Events.MessageCreate do
  use Nostrum.Consumer
  require Logger

  alias Nostrum.Struct.Message

  @spec handle(Message.t()) :: :ok | nil
  def handle(msg) do
    Logger.info("Message received: #{msg.content}")
  end
end
