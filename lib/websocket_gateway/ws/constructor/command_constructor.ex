defmodule WebsocketGateway.Constructor.CommandConstructor do
  @behaviour WebsocketGateway.Constructor.Constructor

  def construct(text) do
    %{data: %{message: %{text: text}}}
  end
end
