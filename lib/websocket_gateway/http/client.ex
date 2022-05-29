defmodule WebsocketGateway.Http.Client do
  require Logger

  def get(uri) do
    Logger.debug("HTTP: GET #{uri}")
    HTTPoison.get(uri) |> handle
  end

  defp handle({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, body}
  end

  defp handle({:ok, %HTTPoison.Response{status_code: 404}}) do
    {:error, "HTTP: Not found"}
  end

  defp handle({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, "HTTP: Unexpected error with reason: #{reason}"}
  end
end
