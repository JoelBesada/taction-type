# Definitions of all keys.
# Fingers:
#   1: Thumb
#   2: Index finger
#   3: Middle finger
#   4: Ring finger
#   5: Pinky

class TactionType.KeyDefinitions
  @presses:
    "1": "A"
    "2": "E"
    "3": "T"
    "4": "O"
    "5": "I"

    "1-2": "S"
    "2-3": "R"
    "3-4": "N"
    "4-5": "V"
    "1-3": "D"
    "2-4": "H"
    "3-5": "U"
    "1-4": "L"
    "2-5": "C"
    "1-5": "Y"

    "1-2-3": "BACKSPACE"
    "2-3-4": "M"
    "3-4-5": "W"
    "1-2-4": "G"
    "2-3-5": "K"
    "1-3-4": "B"
    "2-4-5": "P"
    "1-2-5": "J"
    "1-4-5": "F"
    "1-3-5": "X"

    # "1-2-3-4":
    # "2-3-4-5":
    "1-3-4-5": "Q"
    "1-2-4-5": "Z"
    # "1-2-3-5":

    "1-2-3-4-5": " "

  @lookup: _.invert @presses


