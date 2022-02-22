defmodule WebsocketGateway.Constructor.CommandConstructor do
  @behaviour WebsocketGateway.Constructor.ConstructorBehavior

  def construct(text) do
    %{data: %{message: %{text: text}}}
  end

  def construct(text, cmd, user_id) do
    %{
      data: %{
        message: %{
          text: text
        },
        command: %{
          text: cmd,
          id: user_id
        }
      }
    }
  end
end
