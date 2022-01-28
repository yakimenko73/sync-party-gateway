defmodule WebsocketGateway.SocketHandler do
  @behaviour :cowboy_websocket
  require Logger
  require WebsocketGateway.Broker
  alias Registry.WebsocketGateway, as: Websocket
  alias WebsocketGateway.Broker, as: Broker

  def init(request, _state) do
    state = %{registry_key: request.path}

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

    message = Jason.encode!(%{message: %{text: "John Doe left the room"}})
    Broker.send(message, state)

    :ok
  end

  defp handle(%{"message" => _message} = message, state) do
    Logger.debug("WS: Receive chat message: #{inspect(message)}. State: #{inspect(state)}")
    message = Jason.encode!(message)

    Broker.send(message, state)

    {:reply, {:text, message}, state}
  end

  defp handle(%{"command" => command}, state) do
    Logger.debug("WS: Receive command: #{inspect(command)}. State: #{inspect(state)}")

    case command do
      %{"text" => "Join"} ->
        message = Jason.encode!(%{message: %{text: "John Doe joined to the room"}})
        Broker.send(message, state)

        {:reply, {:text, message}, state}

      _ ->
        Logger.debug("WS: Found unhandled command")
        {:ok, state}
    end
  end
end