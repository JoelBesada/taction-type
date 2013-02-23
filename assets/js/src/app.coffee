$ ->
  # Refresh when input devices refreshes
  TactionType.$.on "newinput", -> window.location.reload()
