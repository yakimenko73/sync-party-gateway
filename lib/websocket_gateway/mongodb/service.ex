defmodule WebsocketGateway.MongoDb.Service do
  alias WebsocketGateway.MongoDb.Repository
  alias WebsocketGateway.Utils
  require Logger

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
    body = member |> Map.put(:room_id, room_id)

    {:ok, res} =
      @collection_room_members
      |> Repository.find_one_and_update(
        body,
        %{
          "$set" => Map.put(body, :date, DateTime.utc_now())
        },
        true
      )

    {:ok, res.value["_id"] |> Utils.get_value_from_bson()}
  end

  def remove_room_member(member_id) do
    @collection_room_members
    |> Repository.delete(%{_id: BSON.ObjectId.decode!(member_id)})

    :ok
  end
end
