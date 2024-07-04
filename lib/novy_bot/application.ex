defmodule NovyBot.Application do
  use Application

  # Entry Point of the program, defined by application/1 in mix.exs
  def start(_type, _args) do
    children = [
      NovyBot.Repo,
      NovyBot.GatewayHandler,
      NovyBot.Dispatcher,
      # Nosedrum.Storage.Dispatcher,
      # NovyBot.Core.CommandHandler,
    ]

    options = [strategy: :one_for_one, name: NovyBot.Supervisor]

    Supervisor.start_link(children, options)
  end
end
