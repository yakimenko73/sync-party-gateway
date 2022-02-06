defmodule WebsocketGateway.Http.Client do
  require Logger

  def get(uri) do
    Logger.debug("Http: GET #{uri}")
    HTTPoison.get(uri) |> handle
  end

  defp handle({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, body}
  end

  defp handle({:ok, %HTTPoison.Response{status_code: 404}}) do
    {:ok, "Http: Not found"}
  end

  defp handle({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, "Http: Unexpected error with reason: #{reason}"}
  end
end
