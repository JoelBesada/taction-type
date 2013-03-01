class TactionType.TouchKey
  KEY_GROUPING_INTERVAL = 60

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
  @unpressedTouchKeys: -> _.filter @touchKeys, (touchKey) ->
    not _presses[touchKey.key]
  @isPressed: (key) -> _presses[key]

  @init: =>
    TactionType.$
      .on("touchstart", (e, data) =>
        pressKeys data.touches
        @touches[touch.id] = touch for touch in data.touches
        return if @calibrated or @calibrating
        startCalibration() if _.keys(@touches).length is 5
      )
      .on("touchend", (e, data) =>
        for touch in data.touches
          key = @touches[touch.id].key
          $key(key).removeClass("pressed") if key
          delete @touches[touch.id]
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
    touchKey.$el.attr("data-id", touchKey.key = i + 1) for touchKey, i in touchKeyList

  _presses = {}

  # Keypresses within small intervals of each other
  # are grouped together as one chord
  _pressKeys = _.debounce( =>
    keys = _.keys(_presses).sort()
    _presses = {}
    $key(key).addClass "pressed" for key in keys
    _.defer =>
      $(".pressed").each (index, element) =>
        unless _.findWhere(@touches, key: $(element).data("id"))
          $(element).removeClass("pressed")

    if TactionType.inputDevice
      TactionType.triggerSyncedEvent "keypressed", keys: keys

  , KEY_GROUPING_INTERVAL)

  pressKeys = (touches) ->
    for id, touch of touches
      _presses[touch.key] = true if touch.key
    _pressKeys()

  $key = (key) -> $(".touch-key[data-id=\"#{key}\"]")

$ ->
  TactionType.$.on "ready", TactionType.TouchKey.init
