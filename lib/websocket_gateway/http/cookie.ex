defmodule WebsocketGateway.Http.Cookie do
  alias Plug.Conn.Cookies

  def get_by_name(cookie, name) do
    cookie
    |> decode
    |> case do
      {:ok, %{^name => value}} -> {:ok, value}
      _ -> :notfound
    end
  end

  defp decode(cookie) when is_nil(cookie) do
    {:ok, :empty}
  end

  defp decode(cookie) do
    {:ok, Cookies.decode(cookie)}
  end
end
