defmodule NovyBot.Api.FFXIV.FFlog.Client do
  @behaviour OAuth2.Strategy

  alias NovyBot.Cache

  def client do
    OAuth2.Client.new(
      strategy: OAuth2.Strategy.ClientCredentials,
      client_id: Application.get_env(:novy_bot, :fflogs_client_id),
      client_secret: Application.get_env(:novy_bot, :fflogs_client_secret),
      site: "https://www.fflogs.com"
    )
  end

  def get_token do
    case Cache.get("fflogs_token") do
      nil ->
        IO.inspect("No token found")
        new_token = fetch_new_token()
        store_token(new_token)
        new_token

      token ->
        IO.inspect("Token found")
        token
    end
  end

  defp fetch_new_token do
    IO.inspect("Fetching new token")

    client()
    |> OAuth2.Client.get_token!()
    |> Map.get(:token)
    |> Map.get(:access_token)
    |> Jason.decode!()
    |> Map.get("access_token")
  end

  defp store_token(token) do
    Cache.put("fflogs_token", token, ttl: :timer.minutes(43_800))
  end

  # GRAPHQL
  def post(graphql) do
    token = get_token()
    base_url = "https://www.fflogs.com/api/v2/client"
    auth = {:bearer, token}

    Req.new(base_url: base_url, auth: auth)
    |> AbsintheClient.attach()
    |> Req.post(graphql: graphql)
    |> handle_response()
  end

  defp handle_response({:ok, %Req.Response{status: 200, body: %{"data" => data}}}),
    do: {:ok, data}

  defp handle_response({:ok, %Req.Response{status: 404, body: %{body: %{"message" => message}}}}),
    do: {:error, message}

  defp handle_response({:error, reason}) do
    {:error, reason}
  end
end
