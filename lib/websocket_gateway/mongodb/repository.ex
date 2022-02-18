defmodule WebsocketGateway.MongoDb.Repository do
  def list(collection, body, limit, sort) do
    :mongo |> Mongo.find(collection, body, sort: sort, limit: limit)
  end

  def add(collection, body) do
    :mongo |> Mongo.insert_one(collection, body)
  end
end
