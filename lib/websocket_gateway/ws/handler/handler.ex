defmodule WebsocketGateway.Handler.Handler do
  @behaviour :cowboy_websocket
  require Logger
  alias Registry.WebsocketGateway, as: Websocket
  alias WebsocketGateway.Handler.CommandHandler
  alias WebsocketGateway.Handler.MessageHandler
  alias WebsocketGateway.SyncParty.Service, as: SyncPartyService

  def init(request, _state) do
    session_info = SyncPartyService.get_session_info(request)

    state = %{
      registry_key: request.path,
      user: session_info,
      room_key: retrieve_room_key(request)
    }

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    Websocket
    |> Registry.register(state.registry_key, {})

    {:ok, state}
  end

  def websocket_handle({:text, json}, state) do
    payload = Jason.decode!(json)
    payload["data"] |> handle(state)
  end

  def websocket_info(info, state) do
    {:reply, {:text, info}, state}
  end

  def terminate(_reason, _req, state) do
    Logger.debug("WS: Terminate connection. State: #{inspect(state)}")
    CommandHandler.handle(%{"text" => "Left"}, state)
  end

  defp handle(%{"message" => message}, state) do
    Logger.debug("WS: Receive chat message: #{inspect(message)}. State: #{inspect(state)}")
    MessageHandler.handle(message, state)
  end

  defp handle(%{"command" => command}, state) do
    Logger.debug("WS: Receive command: #{inspect(command)}. State: #{inspect(state)}")
    CommandHandler.handle(command, state)
  end

  defp retrieve_room_key(request) do
    request.path
    |> String.split("/")
    |> List.last()
  end
end
