keyHeldDown = 0

document.onreadystatechange =  () ->
  switch (state = document.readyState)
    when 'interactive'
      init()
    when 'complete'
      readied()

init = ->
readied = ->
  inputs = document.getElementsByTagName('input')
  for input in inputs
    do (input) ->
      input.onkeydown = (evt) ->
        evt.preventDefault()

        if keyHeldDown == evt.keyCode
          return

        if evt.keyCode == 27
          input.blur()
          return

        unless keyHeldDown
          keyHeldDown = evt.keyCode
          input.value = bindings[evt.keyCode] or (String.fromCharCode evt.keyCode)
          resizeInput input
          if input.nextElementSibling
            # on first keypress, clear the second key element
            input.nextElementSibling.nextElementSibling.value = ''
        else
          # second keypress
          if input.nextElementSibling
            # not for the leader key
            input.nextElementSibling.classList.remove 'hidden'
            input.nextElementSibling.nextElementSibling.classList.remove 'hidden'
            input.nextElementSibling.nextElementSibling.value =
              bindings[evt.keyCode] or (String.fromCharCode evt.keyCode)
            input.blur()
            keyHeldDown = 0

      input.addEventListener 'keyup', (evt) ->
        if evt.keyCode == keyHeldDown
          keyHeldDown = 0
        if input.nextElementSibling
          input.nextElementSibling.classList.add 'hidden'
          input.nextElementSibling.nextElementSibling.classList.add 'hidden'

resizeInput = (input) ->
  input.size = input.value.length

bindings =
  8  : "BACKSPACE"
  9  : "TAB"
  13 : "ENTER"
  16 : "SHIFT"
  17 : "CTRL"
  18 : "ALT"
  19 : "PAUSE/BREAK"
  20 : "CAPS LOCK"
  27 : "ESCAPE"
  33 : "PAGE UP"
  34 : "PAGE DOWN"
  35 : "END"
  36 : "HOME"
  37 : "LEFT ARROW"
  38 : "UP ARROW"
  39 : "RIGHT ARROW"
  40 : "DOWN ARROW"
  45 : "INSERT"
  46 : "DELETE"
  91 : "LCMD"
  92 : "RIGHT WINDOW"
  93 : "RCMD"
  96 : "NUM-0"
  97 : "NUM-1"
  98 : "NUM-2"
  99 : "NUM-3"
  100: "NUM-4"
  101: "NUM-5"
  102: "NUM-6"
  103: "NUM-7"
  104: "NUM-8"
  105: "NUM-9"
  106: "MULTIPLY"
  107: "ADD"
  109: "SUBTRACT"
  110: "DOT"
  111: "DIVIDE"
  112: "F1"
  113: "F2"
  114: "F3"
  115: "F4"
  116: "F5"
  117: "F6"
  118: "F7"
  119: "F8"
  120: "F9"
  121: "F10"
  122: "F11"
  123: "F12"
  144: "NUM LOCK"
  145: "SCROLL LOCK"
  186: ";"
  187: "="
  188: ","
  189: "-"
  190: "."
  191: "/"
  192: "`"
  219: "["
  220: "\\"
  221: "]"
  222: "'"
