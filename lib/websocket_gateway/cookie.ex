defmodule WebsocketGateway.Cookie do
  alias Plug.Conn.Cookies

  def get_session_id(request) do
    request.headers["cookie"]
    |> decode
    |> (fn
          {:ok, %{"sessionid" => value}} -> {:ok, value}
          _ -> {:error, "Cookie: Session id not found"}
        end).()
  end

  defp decode(cookie) when is_nil(cookie) do
    {:ok, :empty}
  end

  defp decode(cookie) do
    {:ok, Cookies.decode(cookie)}
  end
end
