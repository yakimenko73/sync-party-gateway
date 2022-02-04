defmodule MongoDb.Service do
  alias MongoDb.Repository
  require Logger

  def get_all_rooms() do
    rooms = Repository.list()
    
    {:ok, rooms}
  end
end
