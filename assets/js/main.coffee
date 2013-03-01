#= require_tree lib
#= require_tree src

_.defaults TactionType,
  $: $ TactionType
  inputDevice: "ontouchstart" of window and window.location.hash is "#input"

  triggerSynced: (event, data) ->
    @connection.send JSON.stringify
      event: event
      data: data
    TactionType.$.trigger event, data

$ ->
  TactionType.connection =
    new WebSocket("ws://#{window.location.hostname}:#{TactionType.SOCKET_PORT}")

  TactionType.connection.addEventListener "message", (e) ->
    message = JSON.parse e.data
    TactionType.$.trigger(message.event, message.data)

  TactionType.$.trigger "ready"

