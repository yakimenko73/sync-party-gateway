defmodule WebsocketGateway.Utils do
  require Logger

  def to_atom_keys(map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end

  def bson_encode!(bson) when is_list(bson) do
    bson
    |> List.first()
    |> BSON.ObjectId.encode!()
  end

  def bson_encode!(bson) do
    bson |> BSON.ObjectId.encode!()
  end

  def retrieve_room_key(path) do
    path
    |> String.split("/")
    |> List.last()
  end
end
