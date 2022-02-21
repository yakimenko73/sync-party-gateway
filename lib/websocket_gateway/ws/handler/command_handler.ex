defmodule WebsocketGateway.Handler.CommandHandler do
  require Logger
  alias WebsocketGateway.Broker
  alias WebsocketGateway.Constructor.CommandConstructor
  alias WebsocketGateway.Constructor.MessageConstructor
  alias WebsocketGateway.MongoDb.Service, as: Storage

  @join_room_command_pattern "nickname joined to the room"
  @left_room_command_pattern "nickname left the room"
  @initial_message_sending_limit 50

  def handle(%{"text" => "Join"}, state) do
    send_chat_messages(state)
    Storage.add_room_member(state.room_key, state.user)

    join_message =
      @join_room_command_pattern
      |> get_message_by_pattern(state.user.nickname)
      |> CommandConstructor.construct()
      |> Jason.encode!()

    Broker.send(join_message, state)

    {:reply, {:text, join_message}, state}
  end

  def handle(%{"text" => "Left"}, state) do
    @left_room_command_pattern
    |> get_message_by_pattern(state.user.nickname)
    |> CommandConstructor.construct()
    |> Jason.encode!()
    |> Broker.send(state)
  end

  def handle(%{"text" => command}, state) do
    Logger.warning("WS: Receive unhandled command: #{inspect(command)}")

    {:ok, state}
  end

  defp send_chat_messages(state) do
    {_, messages} = Storage.get_last_messages(state.room_key, @initial_message_sending_limit)

    for message <- messages do
      MessageConstructor.construct(message["text"], %{
        nickname: message["author"],
        color: message["color"]
      })
      |> Jason.encode!()
      |> Broker.self_only_send()
    end
  end

  defp get_message_by_pattern(pattern, nickname) do
    pattern |> String.replace("nickname", nickname, global: false)
  end
end
