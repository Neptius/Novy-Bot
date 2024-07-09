defmodule NovyBotTest.Dota do
  use ExUnit.Case, async: true
  alias NovyBot.Dota.Queries.GetPlayer

  describe "Test de la récupération du joueur" do
    test "Récupére le nom du joueur par un Steam32ID valide" do
      assert {:ok, "Neptius"} = GetPlayer.call(135_612_089)
    end

    test "Récupère le nom du joueur par un Steam32ID invalide" do
      assert {:error, "Player not found"} = GetPlayer.call(0)
    end
  end
end
