defmodule NovyBotTest.Dota do
  use ExUnit.Case, async: true
  alias NovyBot.Dota.Queries.GetPlayers

  describe "Test de la récupération du joueur" do
    test "Récupére le joueur par un Steam32ID valide" do
      assert {:ok, "Neptius"} = GetPlayers.call(135612089)
    end

    test "Récupère le joueur par un Steam32ID invalide" do
      assert {:error, "Player not found"} = GetPlayers.call(0)
    end
  end
end
