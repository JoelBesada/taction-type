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
  x: getX touch
  y: getY touch
  key: determineKey touch
} for touch in touches

getX = (touch) -> touch.pageX / document.width
getY = (touch) -> touch.pageY / document.height

# Return the closest key for the given touch
determineKey = (touch) ->
  return null unless TactionType.TouchKey.calibrated
  id = $(touch.target).data("id")
  return id if id
  x = getX touch
  y = getY touch

  # Not actual distances, but good enough for finding the closest key
  distances = _.map TactionType.TouchKey.touchKeys, (touchKey) ->
    key: touchKey.key
    distance: Math.abs(touchKey.x - x) + Math.abs(touchKey.y - y)

  _.min(distances, (item) -> item.distance).key

$ ->
  return unless TactionType.inputDevice
  TactionType.$.on "ready", ->
    $("body").addClass "input"
    TactionType.inputDevice = true
    TactionType.connection.onopen = setupTouchListeners
