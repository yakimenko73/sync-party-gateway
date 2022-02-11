defmodule WebsocketGateway.Utils do
  require Logger
  def to_atom_keys(map) do
    for {key, val} <- map, into: %{}, do: {String.to_atom(key), val}
  end
end
