defmodule WebsocketGatewayTest do
  use ExUnit.Case
  doctest WebsocketGateway

  test "greets the world" do
    assert WebsocketGateway.hello() == :world
  end
end
