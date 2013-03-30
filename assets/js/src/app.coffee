$ ->
  # Refresh when input devices refreshes
  TactionType.$.on "newinput", -> window.location.reload()

  # Send keyboard key press events to all devices
  $(document).on "keypress", (e) ->
    TactionType.triggerSynced "charpress", keyCode: e.which
