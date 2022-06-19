defmodule WebsocketGateway.SyncParty.Api do
  alias WebsocketGateway.Http.Client, as: HttpClient
  alias WebsocketGateway.Utils
  require Logger

  @sessions_api "http://localhost:8000/api/sessions"

  def get_session(session_key) do
    HttpClient.get("#{@sessions_api}/#{session_key}/") |> handle(session_key)
  end

  defp handle({:ok, body}, session_key) do
    Logger.debug("Session: #{session_key} | Info: #{body}")
    {:ok, body |> Jason.decode!() |> Utils.to_atom_keys()}
  end

  defp handle({:error, message}, session_key) do
    message = "HTTP: #{message} | SessionId: #{session_key}"
    {:error, message}
  end
end
