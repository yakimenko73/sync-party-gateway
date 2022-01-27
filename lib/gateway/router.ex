defmodule WebsocketGateway.Router do
  use Plug.Router
  plug Plug.Logger
  plug Plug.Parsers,
       parsers: [:json],
       pass: ["application/json"],
       json_decoder: Jason

  plug :match
  plug :dispatch

  match _ do
    send_resp(conn, 404, "404")
  end
end