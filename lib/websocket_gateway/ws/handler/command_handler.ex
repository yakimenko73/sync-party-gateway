defmodule WebsocketGateway.Handler.CommandHandler do
  require Logger
  alias WebsocketGateway.Broker
  alias WebsocketGateway.Constructor.CommandConstructor

  @join_room_command_pattern "nickname joined to the room"
  @left_room_command_pattern "nickname left the room"

  def handle(%{"text" => "Join"}, state) do
    message =
      @join_room_command_pattern
      |> String.replace("nickname", state.user.nickname, global: false)
      |> CommandConstructor.construct()
      |> Jason.encode!()

    Broker.send(message, state)

    {:reply, {:text, message}, state}
  end

  def handle(%{"text" => "Left"}, state) do
    @left_room_command_pattern
    |> String.replace("nickname", state.user.nickname, global: false)
    |> CommandConstructor.construct()
    |> Jason.encode!()
    |> Broker.send(state)
  end

  def handle(%{"text" => command}, state) do
    Logger.warning("WS: Receive unhandled command: #{inspect(command)}")

    {:ok, state}
  end
end
