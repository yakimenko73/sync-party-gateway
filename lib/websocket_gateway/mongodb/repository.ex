defmodule WebsocketGateway.MongoDb.Repository do
  @collection "rooms_room"

  def list() do
    :mongo |> Mongo.find(@collection, %{})
  end
end
