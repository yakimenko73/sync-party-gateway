defmodule WebsocketGateway.SocketHandler do
  @behaviour :cowboy_websocket
  require Logger
  alias Registry.WebsocketGateway, as: Websocket

  def init(request, _state) do
    Logger.debug(request)
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

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end

  defp handle(%{"message" => _} = message, state) do
    Logger.debug("WS: Receive user message: #{inspect(message)}")
    message = Jason.encode!(message)

    Websocket
    |> Registry.dispatch(
      state.registry_key,
      fn entries ->
        for {pid, _} <- entries do
          if pid != self() do
            Process.send(pid, message, [])
          end
        end
      end
    )

    {:reply, {:text, message}, state}
  end

  defp handle(%{"command" => _} = command, state) do
    Logger.debug("WS: Receive command: #{inspect(command)}")

    Logger.debug(state)

    {:ok, state}
  end
end
