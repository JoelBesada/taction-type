#= require_tree lib
#= require_tree src

$ ->
  TactionType.connection =
    new WebSocket("ws://#{window.location.hostname}:#{TactionType.SOCKET_PORT}")

  TactionType.$ = $ TactionType

  if 'ontouchstart' of window && window.location.hash is "#input"
    TactionType.input.init() # Input device
  else
    TactionType.app.init() # Computer

  TactionType.TouchPoint.init()
  TactionType.TouchKey.init()

