defmodule NovyBotTest do
  use ExUnit.Case
  doctest NovyBot

  test "greets the world" do
    assert NovyBot.hello() == :world
  end
end
