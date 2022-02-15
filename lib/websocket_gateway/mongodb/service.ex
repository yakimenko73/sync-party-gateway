defmodule WebsocketGateway.MongoDb.Service do
  alias WebsocketGateway.MongoDb.Repository

  def get_messages(chat_id, limit) do
    messages =
      Repository.list("chat_#{chat_id}", limit, %{date: -1})
      |> Enum.to_list()

    {:ok, messages}
  end

  def save_message(chat_id, text, user) do
    Repository.add("chat_#{chat_id}", %{
      text: text,
      author: user.nickname,
      color: user.color,
      date: DateTime.utc_now()
    })

    :ok
  end
end
