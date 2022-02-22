defmodule WebsocketGateway.MongoDb.Repository do
  # may be carry ?
  def list(collection, body, limit, sort) do
    :mongo |> Mongo.find(collection, body, sort: sort, limit: limit)
  end

  def add(collection, body) do
    :mongo |> Mongo.insert_one(collection, body)
  end

  def find_one_and_update(collection, filter, body, upsert) do
    :mongo
    |> Mongo.find_one_and_update(
      collection,
      filter,
      body,
      upsert: upsert,
      return_document: :after
    )
  end

  def delete(collection, filter) do
    :mongo |> Mongo.delete_one(collection, filter)
  end
end
