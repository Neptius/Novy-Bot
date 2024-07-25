defmodule NovyBot.Api.FFXIV.Tomestone.Client do
  alias NovyBot.Cache

  @base_url "https://tomestone.gg/api"

  defp headers do
    access_token = Application.get_env(:novy_bot, :tomestone_access_token)

    [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"},
      {"Authorization", "Bearer #{access_token}"}
    ]
  end

  def get(path) do
    Req.get(@base_url <> path, headers: headers())
    |> handle_response()
  end

  defp handle_response({:ok, %Req.Response{status: 200, body: data}}),
    do: {:ok, data}

  defp handle_response({:ok, %Req.Response{status: 404, body: %{"error" => message}}}),
    do: {:error, message}

  defp handle_response({:error, reason}) do
    {:error, reason}
  end
end
