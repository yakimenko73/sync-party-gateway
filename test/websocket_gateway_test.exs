defmodule WebsocketGatewayTest do
  use ExUnit.Case
  doctest WebsocketGateway

  test "Context is load" do
    assert WebsocketGateway.context() == :loaded
  end
end
