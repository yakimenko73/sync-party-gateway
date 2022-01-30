defmodule WebsocketGateway do
  use Application
  require Logger

  def start(_type, _args) do
    ip = Application.get_env(:websocket_gateway, :ip, {127, 0, 0, 1})
    port = Application.get_env(:websocket_gateway, :port, 4000)
    timeout = Application.get_env(:websocket_gateway, :timeout, 60000)
    ws_endpoint = Application.get_env(:websocket_gateway, :ws_endpoint, "ws")

    Logger.debug("Config: #{port}, #{timeout}, #{ws_endpoint}")

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: WebsocketGateway.Router,
        options: [
          dispatch: dispatch(ws_endpoint, timeout),
          port: port,
          ip: ip
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.WebsocketGateway
      )
    ]

    opts = [strategy: :one_for_one, name: WebsocketGateway.Application]
    Supervisor.start_link(children, opts)
  end

  defp dispatch(endpoint, timeout) do
    [
      {
        :_,
        [
          {"/#{endpoint}/[...]", WebsocketGateway.SocketHandler,
           [
             timeout: timeout
           ]},
          {:_, Plug.Cowboy.Handler, {WebsocketGateway.Router, []}}
        ]
      }
    ]
  end
end
