# Displays a single touch point on the screen
class TactionType.TouchPoint
  constructor: (@id) ->
    @$el = @createElement()
    $("body").append @$el
    @$el.addClass "show"

  createElement: ->
    $("<div>")
      .addClass("touch-point")
      .css(
        "background-color",
        "red"
        # "rgba(#{_.random 255}, #{_.random 255}, #{_.random 255}, 0.5)"
      )

  move: (x, y) ->
    @$el.css
      "webkit-transform": "translateX(#{x * document.width}px)
                           translateY(#{y * document.height}px)
                           translateZ(0)"

  remove: ->
    @$el.removeClass "show"
    setTimeout( =>
      @$el.remove()
    , 250)
