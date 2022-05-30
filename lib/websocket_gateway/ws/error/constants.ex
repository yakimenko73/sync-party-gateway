defmodule WebsocketGateway.Error.Constants do
  use Constants

  define server_internal_error, "InternalError"
  define cookie_error, "CookieDoesNotExist"
  define already_in_room_error, "UserAlreadyInRoom"
end
