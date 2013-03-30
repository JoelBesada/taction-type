#= require_tree lib
#= require_tree src

# Extend the global TactionType object with a couple of methods
_.defaults TactionType,
  # jQueryfied version of TactionType, used to listen to and trigger events
  $: $ TactionType

  # Is this an input device?
  inputDevice: "ontouchstart" of window and window.location.hash is "#input"

  # Trigger an event across all connected devices through the WebSocket.
  # This also triggers the event locally.
  triggerSynced: (event, data) ->
    @connection.send JSON.stringify
      event: event
      data: data

    TactionType.$.trigger event, data

$ ->
  TactionType.connection =
    new WebSocket("ws://#{window.location.hostname}:#{TactionType.SOCKET_PORT}")

  # Trigger events for all incoming messages on the WebSocket connection
  TactionType.connection.addEventListener "message", (e) ->
    message = JSON.parse e.data
    TactionType.$.trigger(message.event, message.data)

  # The application is ready
  TactionType.$.trigger "ready"

