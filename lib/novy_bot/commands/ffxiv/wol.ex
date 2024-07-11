defmodule NovyBot.Commands.FFXIV.Wol do
  require Logger

  alias NovyBot.Api.FFXIV.FFlog.Wol

  def name(), do: "wol"

  def description(), do: "Résumé de votre personnage."

  def type(), do: :slash

  def options(), do: []

  def execute(_interaction) do
   [
    content: "Derp!",
   ]
  end
end
