# Listen for touch events and send them out through the socket
setupTouchListeners = ->
  # Register with the server as an input device
  TactionType.connection.send "INPUT_DEVICE"
  $(document)
    .on("touchstart touchmove touchend touchcancel touchleave", (e) ->
      e.preventDefault()
      e.stopPropagation()
    )
    .on("touchstart", (e) ->
      triggerEvent "touchstart",
        touches: formatTouches e.originalEvent.changedTouches
    )
    .on("touchmove", (e) ->
      # Throttle the events for a consistent update rate
      triggerThrottledEvent "touchmove"
        touches: formatTouches e.originalEvent.touches
    )
    .on("touchend touchcancel touchleave", (e) ->
      triggerEvent "touchend"
        touches: formatTouches e.originalEvent.changedTouches
    )

triggerEvent = (event, data) ->
  TactionType.triggerSyncedEvent event, data
triggerThrottledEvent = _.throttle(triggerEvent, 10)

# Pick out the info we are interested in from the list of touches
formatTouches = (touches) -> {
  id: touch.identifier
  x: touch.pageX / document.width
  y: touch.pageY / document.height
  key: $(touch.target).data("id")
} for touch in touches

$ ->
  return unless TactionType.inputDevice
  TactionType.$.on "ready", ->
    $("body").addClass "input"
    TactionType.inputDevice = true
    TactionType.connection.onopen = setupTouchListeners
