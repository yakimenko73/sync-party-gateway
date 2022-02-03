defmodule WebsocketGateway.Supervisor do
  def init() do
    import Supervisor.Spec

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: WebsocketGateway.Router,
        options: [
          dispatch: dispatch(),
          port: port(),
          ip: ip()
        ]
      ),
      Registry.child_spec(
        keys: :duplicate,
        name: Registry.WebsocketGateway
      ),
      worker(Mongo, [[name: :mongo, database: database(), pool_size: 3]])
    ]

    opts = [strategy: :one_for_one, name: WebsocketGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch() do
    [
      {
        :_,
        [
          {"/#{endpoint()}/[...]", WebsocketGateway.SocketHandler,
           [
             timeout: timeout()
           ]},
          {:_, Plug.Cowboy.Handler, {WebsocketGateway.Router, []}}
        ]
      }
    ]
  end

  defp port, do: Application.get_env(:websocket_gateway, :port, 4000)

  defp ip, do: Application.get_env(:websocket_gateway, :ip, {127, 0, 0, 1})

  defp endpoint, do: Application.get_env(:websocket_gateway, :ws_endpoint, "ws")

  defp timeout, do: Application.get_env(:websocket_gateway, :timeout, 60000)

  defp database, do: Application.get_env(:websocket_gateway, :database, "sync-party")
end
