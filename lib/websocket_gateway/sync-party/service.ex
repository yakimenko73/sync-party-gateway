defmodule WebsocketGateway.SyncParty.Service do
  alias WebsocketGateway.Http.Cookie
  alias WebsocketGateway.Http.Client, as: HttpClient
  alias WebsocketGateway.Utils
  require Logger

  @sessions_api "http://127.0.0.1:8000/api/sessions"
  @session_id_cookie_name "sessionid"

  def get_session_info(%{headers: %{"cookie" => cookie}}) do
    session_id = Cookie.get_by_name(cookie, @session_id_cookie_name)

    case session_id do
      {:ok, id} ->
        HttpClient.get("#{@sessions_api}/#{id}/") |> handle_session_info(id)

      :notfound ->
        message = "Session/Cookie: Session id not found | Cookie: #{cookie}"
        {:error, message}
    end
  end

  def get_session_info(%{headers: headers}) do
    message = "Session/Cookie: Cookie header not found | Headers: #{inspect(headers)}"
    {:error, message}
  end

  def get_session_info(request) do
    message = "WS: Unexpected request: #{inspect(request)}"
    {:error, message}
  end

  defp handle_session_info({:ok, body}, session_id) do
    Logger.debug("Session: #{session_id} | Info: #{body}")
    {:ok, body |> Jason.decode!() |> Utils.to_atom_keys()}
  end

  defp handle_session_info({:error, message}, session_id) do
    message = "HTTP: #{message} | SessionId: #{session_id}"
    {:error, message}
  end
end
