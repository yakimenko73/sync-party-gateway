defmodule WebsocketGateway.Constructor.MessageConstructor do
  @behaviour WebsocketGateway.Constructor.Constructor

  def construct(text) do
    %{message: %{text: text}}
  end

  def construct(text, %{nickname: nickname, color: color}) do
    %{message: %{text: text, nickname: nickname, color: color}}
  end

  def construct(text, %{nickname: nickname}) do
    %{message: %{text: text, nickname: nickname}}
  end
end
