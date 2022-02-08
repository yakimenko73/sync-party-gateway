defmodule WebsocketGateway.Handler.MessageHandler do
  require Logger
  alias WebsocketGateway.Broker
  alias WebsocketGateway.Constructor.MessageConstructor

  def handle(%{"text" => text}, state) do
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
