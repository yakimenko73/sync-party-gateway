defmodule WebsocketGateway.Constructor.MessageConstructor do
  @behaviour WebsocketGateway.Constructor.Constructor

  def construct(text) do
    %{data: %{message: %{text: text}}}
  end

  def construct(text, %{nickname: nickname, color: color}) do
    %{data: %{message: %{text: text, nickname: nickname, color: color}}}
  end

  def construct(text, %{nickname: nickname}) do
    %{data: %{message: %{text: text, nickname: nickname}}}
  end
end
