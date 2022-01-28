defmodule WebsocketGateway.SocketHandler.CommandHandler do
  require Logger
  require WebsocketGateway.Broker
  alias WebsocketGateway.Broker, as: Broker

  def handle(%{"text" => "Join"}, state) do
    message = Jason.encode!(%{message: %{text: "John Doe joined to the room"}})
    Broker.send(message, state)

    {:reply, {:text, message}, state}
  end

  def handle(%{"text" => "Left"}, state) do
    message = Jason.encode!(%{message: %{text: "John Doe left the room"}})
    Broker.send(message, state)
  end

  def handle(%{"text" => command}, state) do
    Logger.warning("WS: Receive unhandled command: #{inspect(command)}")

    {:ok, state}
  end
end
