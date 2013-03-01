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
        touches: formatTouches(e.originalEvent.touches, true)
    )
    .on("touchend touchcancel touchleave", (e) ->
      triggerEvent "touchend"
        touches: formatTouches e.originalEvent.changedTouches
    )

triggerEvent = (event, data) ->
  TactionType.triggerSynced event, data
triggerThrottledEvent = _.throttle(triggerEvent, 10)

# Pick out the info we are interested in from the list of touches
formatTouches = (touches, move) ->
  list = []
  pressedNow = {}
  for touch in touches
    formatted =
      id: touch.identifier
      x: touch.pageX / document.width
      y: touch.pageY / document.height

    unless move
      key = determineKey touch, pressedNow
      pressedNow[key] = true
      formatted["key"] = key

    list.push formatted
  list

# Return the closest key for the given touch
determineKey = (touch, pressedNow) ->
  return null unless TactionType.TouchKey.calibrated
  key = $(touch.target).data("id")
  return key if key and not (TactionType.TouchKey.isPressed key or pressedNow key)
  x = touch.pageX
  y = touch.pageY

  availableKeys = _.filter TactionType.TouchKey.unpressedTouchKeys(), (touchKey) ->
    not pressedNow[touchKey.key]

  # Not actual distances, but good enough for finding the closest key
  distances = _.map availableKeys, (touchKey) ->
    key: touchKey.key
    distance: Math.abs(touchKey.x * document.width - touch.pageX) +
              Math.abs(touchKey.y * document.height - touch.pageY)

  _.min(distances, (item) -> item.distance)?.key

$ ->
  return unless TactionType.inputDevice
  TactionType.$.on "ready", ->
    $("body").addClass "input"
    TactionType.inputDevice = true
    TactionType.connection.onopen = setupTouchListeners
