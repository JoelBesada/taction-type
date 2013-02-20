touchPoints = {}
calibrated = false

# Listen for incoming messages (touch input from other devices)
# and render it out on the page
triggerInputEvents = (e) ->
  data = JSON.parse e.data
  TactionType.$.trigger("touch#{data.type}", data)

TactionType.app = {
  init: ->
    TactionType.connection.addEventListener("message", triggerInputEvents)
}
