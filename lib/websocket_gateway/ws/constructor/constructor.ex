defmodule WebsocketGateway.Constructor.ConstructorBehavior do
  @callback construct(text :: charlist()) :: map
end
