defmodule WebsocketGateway.SyncParty.Service do
  alias WebsocketGateway.Http.Cookie
  alias WebsocketGateway.Http.Client, as: HttpClient
  alias WebsocketGateway.Utils
  require Logger

  @sessions_api "http://127.0.0.1:8000/api/sessions"
  @default_session_data %{nickname: "John Doe", color: "red"}
  @session_id_cookie_name "sessionid"
  @default_data_log_pattern "Use default session data: #{inspect(@default_session_data)}"

  def get_session_info(%{headers: %{"cookie" => cookie}}) do
    session_id = Cookie.get_by_name(cookie, @session_id_cookie_name)

    case session_id do
      {:ok, id} ->
        HttpClient.get("#{@sessions_api}/#{id}/") |> handle(id)

      _ ->
        Logger.warning(
          "Session: Session id not found. Cookie: #{cookie} | #{@default_data_log_pattern}"
        )

        @default_session_data
    end
  end

  def get_session_info(%{headers: headers}) do
    Logger.warning("Session: Cookie header not found | #{inspect(headers)} | #{@default_data_log_pattern}")

    @default_session_data
  end

  def get_session_info(request) do
    Logger.warning(
      "Session: Unexpected request from Websocket | #{inspect(request)} | #{@default_data_log_pattern}"
    )

    @default_session_data
  end

  defp handle({:ok, body}, session_id) do
    Logger.debug("Session: #{session_id} | Info: #{body}")
    body |> Jason.decode!() |> Utils.to_atom_keys()
  end

  defp handle({:error, message}, session_id) do
    Logger.warning("#{message} | Session: #{session_id} | #{@default_data_log_pattern}")

    @default_session_data
  end
end
