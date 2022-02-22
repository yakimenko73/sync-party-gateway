defmodule WebsocketGateway.Handler.CommandHandler do
  require Logger
  alias WebsocketGateway.Broker
  alias WebsocketGateway.Constructor.CommandConstructor
  alias WebsocketGateway.Constructor.MessageConstructor
  alias WebsocketGateway.MongoDb.Service, as: Storage

  @join_room_command_pattern "nickname joined to the room"
  @left_room_command_pattern "nickname left the room"
  @initial_message_sending_limit 50

  def handle(%{"text" => "Join" = cmd}, state) do
    {:ok, member_id} = Storage.add_room_member(state.room_key, state.user)
    state = add_member_id_to_state(state, member_id)

    send_chat_messages(state)

    join_message =
      @join_room_command_pattern
      |> get_message_by_pattern(state.user.nickname)
      |> CommandConstructor.construct(cmd, member_id)
      |> Jason.encode!()

    Broker.send(join_message, state)

    {:reply, {:text, join_message}, state}
  end

  def handle(%{"text" => "Left" = cmd}, state) do
    Storage.remove_room_member(state.room_key, state.user)

    @left_room_command_pattern
    |> get_message_by_pattern(state.user.nickname)
    |> CommandConstructor.construct(cmd, state.user.id)
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

  defp add_member_id_to_state(state, id) do
    %{state | user: state.user |> Map.put(:id, id)}
  end
end
