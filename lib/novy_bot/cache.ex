defmodule NovyBot.Cache do
  @moduledoc """
  A simple cache module that uses Redix to store key-value pairs with a TTL.
  """

  @ttl 3600

  def put(key, value) do
    :redix
    |> Redix.command(["SET", key, value, "EX", @ttl])
    |> handle_response()
  end

  def put(key, value, ttl) do
    :redix
    |> Redix.command(["SET", key, value, "EX", Integer.to_string(ttl)])
    |> handle_response()
  end

  def get(key) do
    :redix
    |> Redix.command(["GET", key])
    |> handle_response()
  end

  defp handle_response({:ok, response}), do: {:ok, response}
  defp handle_response({:error, reason}), do: {:error, reason}
end
