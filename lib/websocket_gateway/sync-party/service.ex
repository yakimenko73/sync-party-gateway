defmodule WebsocketGateway.SyncParty.Service do
  alias WebsocketGateway.Http.Cookie
  alias WebsocketGateway.SyncParty.Api, as: SyncPartyApi
  require Logger

  @session_key_cookie_name "sessionid"

  def get_session_info(%{headers: %{"cookie" => cookie}}) do
    session_key = Cookie.get_by_name(cookie, @session_key_cookie_name)

    case session_key do
      {:ok, key} ->
        SyncPartyApi.get_session(key) |> add_session_key(key)

      :notfound ->
        message = "Session/Cookie: Session key not found | Cookie: #{cookie}"
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

  defp add_session_key({:ok, info}, key), do: {:ok, Map.put(info, :key, key)}

  defp add_session_key({:error, message}, _key), do: {:error, {:api, message}}
end
