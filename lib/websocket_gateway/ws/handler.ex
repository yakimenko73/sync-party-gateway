defmodule WebsocketGateway.SocketHandler.Handler do
  @behaviour :cowboy_websocket
  require Logger
  alias Registry.WebsocketGateway, as: Websocket
  alias WebsocketGateway.Broker
  alias WebsocketGateway.SocketHandler.CommandHandler
  alias WebsocketGateway.Cookie
  alias WebsocketGateway.Http.Client, as: HttpClient

  @default_user_nickname "John Doe"
  @sessions_api "http://127.0.0.1:8000/api/sessions"

  def init(request, _state) do
    state = %{registry_key: request.path}
    session_id = Cookie.get_session_id(request)

    case session_id do
      {:ok, id} -> HttpClient.get("#{@sessions_api}/#{id}/")
      {:error, disc} -> Logger.warning(disc)
    end

    state = Map.put(state, :user, %{nickname: @default_user_nickname})

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Websocket
    |> Registry.register(state.registry_key, {})

    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    payload = Jason.decode!(json)
    handle(payload["data"], state)
  end

  def websocket_handle(_frame, _req, state) do
    Logger.debug("WS: Found unhandled message #{inspect(state)}")

    {:ok, state}
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end

  def terminate(_reason, _req, state) do
    Logger.debug("WS: Terminate connection. State: #{inspect(state)}")
    CommandHandler.handle(%{"text" => "Left"}, state)

    :ok
  end

  defp handle(%{"message" => message}, state) do
    Logger.debug("WS: Receive chat message: #{inspect(message)}. State: #{inspect(state)}")
    message = %{message: Map.merge(message, state[:user])} |> Jason.encode()
    Broker.send(message, state)

    {:reply, {:text, message}, state}
  end

  defp handle(%{"command" => command}, state) do
    Logger.debug("WS: Receive command: #{inspect(command)}. State: #{inspect(state)}")
    CommandHandler.handle(command, state)
  end
end
