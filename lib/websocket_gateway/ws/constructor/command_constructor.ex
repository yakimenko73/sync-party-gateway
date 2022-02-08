defmodule WebsocketGateway.Constructor.CommandConstructor do
  @behaviour WebsocketGateway.Constructor.Constructor

  def construct(text) do
    %{message: %{text: text}}
  end
end
