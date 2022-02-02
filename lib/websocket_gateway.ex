defmodule WebsocketGateway do
  use Application
  alias WebsocketGateway.Supervisor, as: Supervisor

  def start(_type, _args) do
    Supervisor.init()
  end
end
