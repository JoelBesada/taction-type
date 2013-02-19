touchPoints = {}

# Listen for incoming messages (touch input from other devices)
# and render it out on the page
handleTouchInput = (e) ->
  data = JSON.parse e.data
  for touch in data.touches
    if data.start
      touchPoints[touch.id] = new TactionType.TouchPoint(touch.id)
    else if data.end
      touchPoints[touch.id]?.remove()
      delete touchPoints[touch.id]
      continue

    touchPoints[touch.id]?.move touch.x, touch.y

TactionType.app = {
  init: ->
    TactionType.connection.onmessage = handleTouchInput
}
