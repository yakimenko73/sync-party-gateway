defmodule WebsocketGateway.Cookie do
  alias Plug.Conn.Cookies
  require Logger

  def get_session_id(request) do
    cookie = decode(request)

    case cookie do
      %{"sessionid" => value} -> {:ok, value}
      _ -> {:error, "Cookie: Session id not found"}
    end
  end

  defp decode(request) do
    cookie = request.headers["cookie"]

    if is_nil(cookie) do
      %{}
    else
      Cookies.decode(cookie)
    end
  end
end
