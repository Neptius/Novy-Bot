defmodule NovyBot.Command do
  alias Nostrum.Struct.{Interaction}

  @callback name() :: String.t()

  @callback description() :: String.t()

  @callback type() :: :slash | :chat_input

  @callback options() :: [Keyword.t()]

  @callback execute(interaction :: Interaction.t()) :: [Keyword.t()]
end
