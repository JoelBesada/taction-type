class TactionType.TouchKey
  KEY_GROUPING_INTERVAL = 20

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
  @lastTime: 0
  @init: ->
    TactionType.$
      .on("touchstart", (e, data) =>
        @touches[touch.id] = touch for touch in data.touches
        pressKeys data.touches
        return if @calibrated or @calibrating
        startCalibration() if _.keys(@touches).length is 5
      )
      .on("touchend", (e, data) =>
        delete @touches[touch.id] for touch in data.touches
        endCalibration() if @calibrating
      )
      .on("touchmove", (e, data) =>
        return unless @calibrating
        @touchKeys[touch.id]?.move touch.x, touch.y for touch in data.touches
      )

  startCalibration = =>
    @calibrating = true
    for id, touch of @touches
      @touchKeys[id] = new @(id, touch.x, touch.y)

  endCalibration = =>
    @calibrating = false
    @calibrated = true
    touchKeyList = _.sortBy((touch for id, touch of @touchKeys), "x")
    $el.attr("data-id", i + 1) for {$el}, i in touchKeyList


  _presses = {}

  # Keypresses withing small intervals of each other
  # are grouped together as one chord
  _pressKeys = _.debounce(->
    console.log _.keys(_presses)
    _presses = {}
  , KEY_GROUPING_INTERVAL)
  pressKeys = (touches) ->
    for id, touch of touches
      _presses[touch.key] = true if touch.key
    _pressKeys()
