defmodule WebsocketGateway.SocketHandler do
  @behaviour :cowboy_websocket
  require Logger
  alias Registry.WebsocketGateway, as: Websocket
  alias WebsocketGateway.Broker
  alias WebsocketGateway.SocketHandler.CommandHandler
  alias MongoDb.Service

  @raw_user_data %{
    "nickname" => "John Doe",
    "color" => "red"
  }

  def init(request, _state) do
    state = %{registry_key: request.path}

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Websocket
    |> Registry.register(state.registry_key, {})

    state = Map.put(state, :user, @raw_user_data)

    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    Logger.debug(inspect(Service.get_all_rooms()))
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
    message = Jason.encode!(%{message: Map.merge(message, state[:user])})
    Broker.send(message, state)

    {:reply, {:text, message}, state}
  end

  defp handle(%{"command" => command}, state) do
    Logger.debug("WS: Receive command: #{inspect(command)}. State: #{inspect(state)}")
    CommandHandler.handle(command, state)
  end
end
