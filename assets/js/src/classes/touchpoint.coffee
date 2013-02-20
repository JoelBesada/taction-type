# Displays a single touch point on the screen
class TactionType.TouchPoint
  constructor: (@id, @x, @y) ->
    @$el = $("<div>").addClass("touch-point")
    $("body").append @$el
    @$el.addClass "show"
    @move x, y

  move: (x, y) ->
    @x = x
    @y = y
    @$el.css
      "webkit-transform": "translateX(#{x * document.width}px)
                           translateY(#{y * document.height}px)
                           translateZ(0)"

  remove: ->
    @$el.removeClass "show"
    setTimeout( =>
      @$el.remove()
    , 250)


  @touchPoints = {}
  @touchCount = -> _.keys(@touchPoints).length
  @init: ->
    return if TactionType.inputDevice

    TactionType.$
      .on("touchstart", (e, data) =>
        for touch in data.touches
          @touchPoints[touch.id] = new @(touch.id, touch.x, touch.y)
      )
      .on("touchend", (e, data) =>
        for touch in data.touches
          @touchPoints[touch.id]?.remove()
          delete @touchPoints[touch.id]
      )
      .on("touchmove", (e, data) =>
        for touch in data.touches
          @touchPoints[touch.id]?.move touch.x, touch.y
      )

