defmodule WebsocketGateway.Utils do
  require Logger
  def to_atom_keys(map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end

  def get_value_from_bson(bson) when is_list(bson) do
    bson
    |> List.first()
    |> BSON.ObjectId.encode!()
  end

  def get_value_from_bson(bson) do
    bson |> BSON.ObjectId.encode!()
  end
end
