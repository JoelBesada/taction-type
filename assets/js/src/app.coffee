$ ->
  # Refresh when input devices refreshes
  TactionType.$.on "newinput", -> window.location.reload()

  $(document).on "keypress", (e) ->
    TactionType.triggerSynced "charpress", keyCode: e.which
