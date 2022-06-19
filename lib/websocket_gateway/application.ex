defmodule WebsocketGateway.Application do
  use Application
  require Logger

  def start(_type, _args) do
    Supervisor.start_link(children(), opts())
  end

  defp children() do
    [
      {Plug.Cowboy,
       scheme: :http,
       plug: WebsocketGateway.Router,
       options: [
         dispatch: dispatch(),
         port: port(),
         ip: ip()
       ]},
      {Registry, keys: :duplicate, name: Registry.WebsocketGateway},
      {
        Mongo,
        [
          name: :mongo,
          database: db_name(),
          pool_size: 3,
          hostname: db_hostname(),
          port: db_port(),
          username: db_username(),
          password: db_password(),
          auth_source: db_name()
        ]
      }
    ]
  end

  defp opts() do
    [strategy: :one_for_one, name: WebsocketGateway.Supervisor]
  end

  defp dispatch() do
    [
      {
        :_,
        [
          {"/#{endpoint()}/[...]", WebsocketGateway.Handler.Handler,
           [
             timeout: timeout()
           ]},
          {:_, Plug.Cowboy.Handler, {WebsocketGateway.Router, []}}
        ]
      }
    ]
  end

  defp port, do: Application.get_env(:websocket_gateway, :port, 8001)

  defp ip, do: Application.get_env(:websocket_gateway, :ip, {127, 0, 0, 1})

  defp endpoint, do: Application.get_env(:websocket_gateway, :ws_endpoint, "ws")

  defp timeout, do: Application.get_env(:websocket_gateway, :timeout, 60000)

  defp db_name, do: Application.get_env(:websocket_gateway, :db_name, "sync-party")

  defp db_hostname, do: Application.get_env(:websocket_gateway, :db_hostname, "localhost")

  defp db_port, do: Application.get_env(:websocket_gateway, :db_port, 27017)

  defp db_username, do: Application.get_env(:websocket_gateway, :db_username, "admin")

  defp db_password, do: Application.get_env(:websocket_gateway, :db_password, "admin")
end
