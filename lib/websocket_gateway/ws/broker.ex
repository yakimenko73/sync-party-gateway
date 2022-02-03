defmodule WebsocketGateway.Broker do
  alias Registry.WebsocketGateway, as: Websocket

  def send(message, state) do
    Websocket
    |> Registry.dispatch(
      state.registry_key,
      fn entries ->
        for {pid, _} <- entries do
          if pid != self() do
            Process.send(pid, message, [])
          end
        end
      end
    )
  end
end
