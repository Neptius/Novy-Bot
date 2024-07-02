defmodule NovyBot.Dota.GraphqlClient do
  @moduledoc """
  Client for the Stratz API
  """

  def post(graphql) do
    token = Application.get_env(:novy_bot, :stratz_token)
    base_url = "https://api.stratz.com/graphql?key=#{token}"
    auth = {:bearer, token}
    Req.new(base_url: base_url, auth: auth)
    |> AbsintheClient.attach()
    |> Req.post(graphql: graphql)
    |> handle_response()
  end

  defp handle_response({:ok, %Req.Response{status: 200, body: %{"data" => data}}}), do: {:ok, data}
  defp handle_response({:ok, %Req.Response{status: 400, body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response({:error, reason}) do
    {:error, reason}
  end
end
