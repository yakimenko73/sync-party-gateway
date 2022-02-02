use Mix.Config

config :websocket_gateway,
       ip: {0, 0, 0, 0},
       port: 4000,
       timeout: 60000,
       ws_endpoint: "ws"
