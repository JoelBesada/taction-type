# Listen for touch events and send them out through the socket
setupTouchListeners = ->
  # Register with the server as an input device
  TactionType.connection.send "INPUT_DEVICE"

  $(document)
    .on("touchstart", (e) ->
      e.preventDefault()
      sendMessage
        start: true
        touches: formatTouches e.originalEvent.changedTouches
    )
    .on("touchmove", (e) ->
      e.preventDefault()

      # Throttle the messages for a consistent update rate
      sendThrottledMessage
        touches: formatTouches e.originalEvent.changedTouches
    )
    .on("touchend touchcancel touchleave", (e) ->
      e.preventDefault()
      sendMessage
        end: true
        touches: formatTouches e.originalEvent.changedTouches
    )

sendMessage = (message) ->
  TactionType.connection.send JSON.stringify(message)

sendThrottledMessage = _.throttle(sendMessage, 10)

# Pick out the info we are interested in from the list of touches
formatTouches = (touches) -> {
  id: touch.identifier
  x: touch.screenX / document.width
  y: touch.screenY / document.height
} for touch in touches

TactionType.input = {
  init: ->
    TactionType.connection.onopen = setupTouchListeners
}
