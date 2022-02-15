defmodule WebsocketGateway.MongoDb.Repository do
  def list(collection, limit, sort) do
    :mongo |> Mongo.find(collection, %{}, sort: sort, limit: limit)
  end

  def add(collection, body) do
    :mongo |> Mongo.insert_one(collection, body)
  end
end
