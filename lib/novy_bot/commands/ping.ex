defmodule NovyBot.Commands.Ping do
  @moduledoc """
  Module pour la commande Ping.
  """

  require Logger

  def command do
    %{
      name: "ping",
      description: "Répond avec Pong!",
      options: []
    }
  end

  def callback(%Nostrum.Struct.Interaction{data: data} = interaction) do
    Logger.info("Commande Ping appelée")
    Nostrum.Api.create_interaction_response(interaction.id, interaction.token, %{type: 4, data: %{content: "Pong!"}})
  end
end
