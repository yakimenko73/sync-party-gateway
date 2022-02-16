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
    join_message =
      @join_room_command_pattern
      |> String.replace("nickname", state.user.nickname, global: false)
      |> CommandConstructor.construct()
      |> Jason.encode!()

    Broker.send(join_message, state)

    send_chat_messages(state)

    {:reply, {:text, join_message}, state}
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

  defp send_chat_messages(state) do
    {_, messages} = Storage.get_last_messages(state.chat_id, @initial_message_sending_limit)

    for message <- messages do
      MessageConstructor.construct(message["text"], %{
        nickname: message["author"],
        color: message["color"]
      })
      |> Jason.encode!()
      |> Broker.self_only_send()
    end
  end
end
