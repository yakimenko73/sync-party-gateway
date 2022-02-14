defmodule WebsocketGateway.MongoDb.Repository do
  def list(collection) do
    :mongo |> Mongo.find(collection, %{})
  end

  def add(collection, body) do
    :mongo |> Mongo.insert_one(collection, body)
  end
end
