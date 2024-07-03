defmodule NovyBot.FFXIV.HttpClient do
  @moduledoc """
  Client for the FFXIV COLLECT API
  """

  def get(path) do
    IO.inspect("https://ffxivcollect.com/api#{path}")

    Req.get("https://ffxivcollect.com/api#{path}")
    |> handle_response()
  end

  defp handle_response({:ok, %Req.Response{status: 200, body: body}}), do: {:ok, body}
  defp handle_response({:ok, %Req.Response{status: 404, body: errors}}), do: {:error, errors}
  defp handle_response({:ok, %Req.Response{status: 400, body: errors}}), do: {:error, errors}

  defp handle_response({:error, reason}) do
    {:error, reason}
  end
end
