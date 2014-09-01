
document.onreadystatechange =  () ->
  switch (state = document.readyState)
    when 'interactive'
      init()
    when 'complete'
      readied()

init = ->
readied = ->
  inputs = document.getElementsByTagName('input')
  console.log inputs
  for input in inputs
    do (input) ->
      input.addEventListener 'keydown', (evt) ->
        console.log 'keydown', input
        input.value = ''
      input.addEventListener 'keyup', (evt) ->
        console.log 'keyup', String.fromCharCode evt.keyCode
        input.value = ''


keybindings:
  "backspace"    : 8
  "tab"          : 9
  "enter"        : 13
  "shift"        : 16
  "ctrl"         : 17
  "alt"          : 18
  "pause/break"  : 19
  "caps lock"    : 20
  "escape"       : 27
  "page up"      : 33
  "page down"    : 34
  "end"          : 35
  "home"         : 36
  "left arrow"   : 37
  "up arrow"     : 38
  "right arrow"  : 39
  "down arrow"   : 40
  "insert"       : 45
  "delete"       : 46
  "left window"  : 91
  "right window" : 92
  "select key"   : 93
  "numpad 0"     : 96
  "numpad 1"     : 97
  "numpad 2"     : 98
  "numpad 3"     : 99
  "numpad 4"     : 100
  "numpad 5"     : 101
  "numpad 6"     : 102
  "numpad 7"     : 103
  "numpad 8"     : 104
  "numpad 9"     : 105
  "multiply"     : 106
  "add"          : 107
  "subtract"     : 109
  "decimal point": 110
  "divide"       : 111
  "F1"           : 112
  "F2"           : 113
  "F3"           : 114
  "F4"           : 115
  "F5"           : 116
  "F6"           : 117
  "F7"           : 118
  "F8"           : 119
  "F9"           : 120
  "F10"          : 121
  "F11"          : 122
  "F12"          : 123
  "num lock"     : 144
  "scroll lock"  : 145
  ";"            : 186
  "="            : 187
  ","            : 188
  "-"            : 189
  "."            : 190
  "/"            : 191
  "`"            : 192
  "["            : 219
  "\\"           : 220
  "]"            : 221
  "'"            : 222
