defmodule WebsocketGateway.MongoDb.Service do
  alias WebsocketGateway.MongoDb.Repository
  alias WebsocketGateway.Utils

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

    @collection_room_members
    |> Repository.find_one_and_update(
      body,
      %{
        "$set" => Map.put(body, :date, DateTime.utc_now())
      },
      true
    )
    |> handle_updated_result()
  end

  def remove_room_member(member_id) do
    @collection_room_members
    |> Repository.delete(%{_id: BSON.ObjectId.decode!(member_id)})

    :ok
  end

  defp handle_updated_result({:ok, %Mongo.FindAndModifyResult{updated_existing: true} = res}),
    do: {:updated, res.value["_id"] |> Utils.bson_encode!()}

  defp handle_updated_result({:ok, %Mongo.FindAndModifyResult{updated_existing: false} = res}),
    do: {:ok, res.value["_id"] |> Utils.bson_encode!()}
end
