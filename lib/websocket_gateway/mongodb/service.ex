defmodule WebsocketGateway.MongoDb.Service do
  alias WebsocketGateway.MongoDb.Repository

  @collection_chat_messages "chatmessages"

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
end
