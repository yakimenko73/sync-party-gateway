defmodule WebsocketGateway.Constructor.CommandConstructor do
  @behaviour WebsocketGateway.Constructor.ConstructorBehavior

  def construct(text) do
    %{data: %{message: %{text: text}}}
  end
end
