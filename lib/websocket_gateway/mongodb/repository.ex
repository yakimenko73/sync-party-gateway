defmodule WebsocketGateway.MongoDb.Repository do
  def list(chat_id) do
    :mongo |> Mongo.find(chat_id, %{})
  end

  def add(chat_id, text, author, color) do
    :mongo |> Mongo.insert_one(chat_id, %{text: text, author: author, color: color})
  end
end
