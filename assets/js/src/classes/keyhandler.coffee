class TactionType.KeyHandler
  $textArea = null
  handleKeyPress = (e, data) ->
    char = TactionType.KeyDefinitions.presses[data.keys.join("-")]
    return unless char
    if char is "BACKSPACE"
      $textArea.text(
        $textArea.text().substring(0, $textArea.text().length - 1)
      )
    else
      $textArea.append(char.toLowerCase()) if char

  @init = ->
    TactionType.$.on "keypressed", handleKeyPress
    $textArea = $ ".text-area"

$ -> TactionType.$.on "ready", TactionType.KeyHandler.init