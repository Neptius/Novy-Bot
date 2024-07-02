defmodule NovyBot.Core.Main do
  use Application

  # Entry Point of the program, defined by application/1 in mix.exs
  def start(_type, _args) do
    children = [
      NovyBot.Repo,
      Nosedrum.Storage.Dispatcher,
      NovyBot.Core.CommandHandler,
      NovyBot.Gateway.Handler
    ]

    options = [strategy: :one_for_one, name: NovyBot.Supervisor]
    Supervisor.start_link(children, options)
  end
end
