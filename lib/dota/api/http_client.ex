defmodule NovyBot.Dota.Api.HttpClient do
  @moduledoc """
  Client for the OpenDota API.
  """

  alias Req.Response

  @base_url "https://api.opendota.com/api"

  @doc """
  Makes a GET request to the OpenDota API.
  """
  def get(endpoint, params \\ %{}) do
    url = "#{@base_url}/#{endpoint}"

    Req.get!(url, params: params)
    |> handle_response()
  end

  defp handle_response(%Response{status: 200, body: body}), do: {:ok, body}

  defp handle_response(%Response{status: status, body: body}),
    do: {:error, %{status: status, body: body}}
end
