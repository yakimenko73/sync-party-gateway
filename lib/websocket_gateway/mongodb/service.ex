defmodule WebsocketGateway.MongoDb.Service do
  alias WebsocketGateway.MongoDb.Repository

  @collection_chat_messages "chatmessages"
  @collection_room_members "roommembers"

  def get_last_messages(chat_id, limit) do
    messages =
      @collection_chat_messages
      |> Repository.list(%{chat_id: chat_id}, limit, %{date: -1})
      |> Enum.to_list()
      |> Enum.reverse()

    {:ok, messages}
  end

  def save_message(chat_id, text, user) do
    @collection_chat_messages
    |> Repository.add(%{
      chat_id: chat_id,
      text: text,
      author: user.nickname,
      color: user.color,
      date: DateTime.utc_now()
    })

    :ok
  end

  def add_room_member(room_id, member) do
    body = %{
      room_id: room_id,
      nickname: member.nickname,
      color: member.color
    }

    @collection_room_members
    |> Repository.update(
      body,
      %{
        "$set" => Map.put(body, :date, DateTime.utc_now())
      },
      true
    )

    :ok
  end

  def remove_room_member(room_id, member) do
    @collection_room_members
    |> Repository.delete(%{
      room_id: room_id,
      nickname: member.nickname,
      color: member.color
    })

    :ok
  end
end
