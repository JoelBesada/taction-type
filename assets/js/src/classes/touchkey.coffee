class TactionType.TouchKey
  constructor: (@id, @x, @y) ->
    @$el = $("<div>").addClass("touch-key")
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

  @calibrated: false
  @calibrating: false
  @touches: {}
  @touchKeys: {}
  @init: ->
    TactionType.$
      .on("touchstart", (e, data) =>
        @touches[touch.id] = touch for touch in data.touches
        return if @calibrated or @calibrating
        if _.keys(@touches).length is 5
          startCalibration()
          @calibrating = true
      )
      .on("touchend", (e, data) =>
        delete @touches[touch.id] for touch in data.touches
        if @calibrating
          @calibrating = false
          @calibrated = true
      )
      .on("touchmove", (e, data) =>
        return unless @calibrating
        for touch in data.touches
          @touchKeys[touch.id]?.move touch.x, touch.y
      )

  startCalibration = =>
    for id, touch of @touches
      @touchKeys[id] = new @(id, touch.x, touch.y)
