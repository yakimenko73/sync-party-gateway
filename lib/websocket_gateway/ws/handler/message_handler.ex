defmodule WebsocketGateway.Handler.MessageHandler do
  require Logger
  alias WebsocketGateway.Broker
  alias WebsocketGateway.Constructor.MessageConstructor
  alias WebsocketGateway.MongoDb.Service, as: Storage

  def handle(%{"text" => text}, state) do
    Storage.save_message(state.room_key, text, state.user)

    message =
      MessageConstructor.construct(text, state.user)
      |> Jason.encode!()

    Broker.send(message, state)

    {:reply, {:text, message}, state}
  end

  def handle(message, state) do
    Logger.warning("WS: Receive unhandled message: #{inspect(message)}")

    {:ok, state}
  end
end
