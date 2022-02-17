defmodule WebsocketGateway.Constructor.ConstructorBehavior do
  @callback construct(text :: string) :: map
end
