# Handle and render the characters of pressed keys
class TactionType.KeyHandler
  $textArea = null

  # Interpret and render key presses as characters
  handleKeyPress = (e, data) =>
    char = TactionType.KeyDefinitions.presses[data.keys.join("-")]
    return unless char
    if char is "BACKSPACE"
     @backspace()
    else
      $textArea.append(char) if char

  # Remove the last letter
  @backspace = ->
   $textArea.text $textArea.text().substring(0, $textArea.text().length - 1)

  @init = ->
    TactionType.$.on "keypressed", handleKeyPress
    $textArea = $ ".text-area"

$ -> TactionType.$.on "ready", TactionType.KeyHandler.init
