defmodule NovyBot.Api.TokenStorage do
  use GenServer

  @table :oauth2_tokens

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    :ets.new(@table, [:named_table, :public, :set])
    {:ok, %{}}
  end

  def store_token(%OAuth2.AccessToken{} = token) do
    :ets.insert(@table, {:token, token})
  end

  def fetch_token do
    case :ets.lookup(@table, :token) do
      [{:token, token}] -> {:ok, token}
      [] -> :error
    end
  end
end
