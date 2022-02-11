defmodule WebsocketGateway.MongoDb.Service do
  alias WebsocketGateway.MongoDb.Repository
  require Logger

  def get_all_messages(chat_id) do
    messages = Repository.list("chat_#{chat_id}")

    {:ok, messages}
  end

  def save_message(chat_id, text, user) do
    messages = Repository.add("chat_#{chat_id}", text, user.nickname, user.color)

    {:ok, messages}
  end
end
