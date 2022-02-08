defmodule WebsocketGateway.MongoDb.Service do
  alias WebsocketGateway.MongoDb.Repository
  require Logger

  def get_all_rooms() do
    rooms = Repository.list()

    {:ok, rooms}
  end
end
