defmodule WebsocketGateway.Handler.Handler do
  @behaviour :cowboy_websocket
  require Logger
  require WebsocketGateway.Error.Constants
  alias WebsocketGateway.Error.Constants, as: ErrorConst
  alias Registry.WebsocketGateway, as: Websocket
  alias WebsocketGateway.Handler.CommandHandler
  alias WebsocketGateway.Handler.MessageHandler
  alias WebsocketGateway.SyncParty.Service, as: SyncPartyService
  alias WebsocketGateway.Utils

  def init(request, _state) do
    state = %{
      request: request,
      registry_key: request.path,
      room_key: Utils.retrieve_room_key(request.path)
    }

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    session_info = SyncPartyService.get_session_info(state.request)

    case session_info do
      {:ok, info} ->
        state = Map.put(state, :session, info)
        Websocket |> Registry.register(state.registry_key, {})

        {:ok, state}

      {:error, message} ->
        Logger.error(inspect(message))

        case message do
          {:api, _message} -> {:reply, {:close, 1011, ErrorConst.server_internal_error}, state}
          _ -> {:reply, {:close, 1000, ErrorConst.cookie_error}, state}
        end
    end
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
end
