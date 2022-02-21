defmodule WebsocketGateway.MongoDb.Repository do
  # may be carry ?
  def list(collection, body, limit, sort) do
    :mongo |> Mongo.find(collection, body, sort: sort, limit: limit)
  end

  def add(collection, body) do
    :mongo |> Mongo.insert_one(collection, body)
  end

  def update_one(collection, filter, body, upsert) do
    :mongo |> Mongo.update_one(collection, filter, body, upsert: upsert)
  end
end
