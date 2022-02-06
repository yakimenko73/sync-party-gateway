import Config

config :websocket_gateway,
       ip: {0, 0, 0, 0},
       port: 8001,
       timeout: 60000,
       ws_endpoint: "ws",
       db_name: "sync-party",
       db_username: "admin",
       db_password: "admin",
       db_hostname: "localhost",
       db_port: 27017
