defmodule NovyBot.Api.Ffxiv.Fflogs.Client do
  @behaviour OAuth2.Strategy

  alias NovyBot.Api.TokenStorage

  def client do
    OAuth2.Client.new(
      strategy: OAuth2.Strategy.ClientCredentials,
      client_id: Application.get_env(:novy_bot, :fflogs_client_id),
      client_secret: Application.get_env(:novy_bot, :fflogs_client_secret),
      site: "https://www.fflogs.com"
    )
  end

  def get_token do
    case TokenStorage.fetch_token() do
      {:ok, %OAuth2.AccessToken{} = token} ->
        IO.inspect(token.expires_at)

        if token.expires_at > System.system_time(:second) do
          IO.inspect("Token still valid")
          token
        else
          IO.inspect("Token expired")
          new_token = fetch_new_token()
          TokenStorage.store_token(new_token)
          new_token
        end

      :error ->
        IO.inspect("No token found")
        new_token = fetch_new_token()
        TokenStorage.store_token(new_token)
        new_token
    end
  end

  @callback fetch_new_token() :: OAuth2.AccessToken.t()
  defp fetch_new_token do
    IO.inspect("Fetching new token")

    client()
    |> OAuth2.Client.get_token!()
    |> Map.get(:token)
  end

  # GRAPHQL
  def post(graphql) do
    %{access_token: token} = get_token()
    base_url = "https://www.fflogs.com/api/v2/client"
    auth = {:bearer, token}

    Req.new(base_url: base_url, auth: auth)
    |> AbsintheClient.attach()
    |> Req.post(graphql: graphql)
    |> handle_response()
  end

  defp handle_response({:ok, %Req.Response{status: 200, body: %{"data" => data}}}),
    do: {:ok, data}

  defp handle_response({:ok, %Req.Response{status: 400, body: %{"errors" => errors}}}),
    do: {:error, errors}

  defp handle_response({:error, reason}) do
    {:error, reason}
  end
end
