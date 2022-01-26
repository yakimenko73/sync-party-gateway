defmodule WebsocketGateway do
  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: WebsocketGateway.Router,
        options: [
          dispatch: dispatch(),
          port: 4000
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

  defp dispatch do
    [
      {:_,
        [
          {"/ws/[...]", WebsocketGateway.SocketHandler, []},
          {:_, Plug.Cowboy.Handler, {WebsocketGateway.Router, []}}
        ]
      }
    ]
  end
end
