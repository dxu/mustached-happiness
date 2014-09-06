keyHeldDown = 0
commands =
  "leader":     [220]           # \
  "move-left":  [17, 65]   # CTRL + a
  "move-right": [17, 68]   # CTRL + d
  "move-down":  [17, 69]   # CTRL + s
  "move-up":    [17, 81]   # CTRL + w
  "extract":    [17, 83]   # CTRL + e
  "pin":        [17, 80]   # CTRL + p
  "incognito":  [17, 73]   # CTRL + i
  "move-num":   [17]        # CTRL
  "options":    [16, 191]  # SHIFT + /



document.onreadystatechange =  () ->
  switch (state = document.readyState)
    when 'interactive'
      init()
    when 'complete'
      readied()

init = ->
  chrome.storage.sync.get null, (items) ->
    commands = if items.length then items else commands

readied = ->
  console.log 'hti', commands
  document.getElementById('save').addEventListener 'click', (evt) ->
    console.log 'saved'
    saveInputs()
    syncInputs()
  document.getElementById('undo').addEventListener 'click', (evt) ->
    console.log 'undo'
  for key, value of commands
    console.log 'hit'
    node = document.getElementById key
    node_arr = [node, node.nextElementSibling?.nextElementSibling,
      node.nextElementSibling?.nextElementSibling]
    for el, index in value

      node_arr[index].value = bindings[el] or (String.fromCharCode el)
      # fill in data attributes
      node_arr[index].dataset.key = el
      node_arr[index].classList.remove('hidden')
      node_arr[index]?.previousElementSibling?.classList.remove('hidden')
      resizeInput node_arr[index]

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
          input.dataset.key = evt.keyCode
          resizeInput input
          if input.nextElementSibling
            # on first keypress, clear the second key element
            input.nextElementSibling.nextElementSibling.value = ''
        else
          # second keypress
          if second_input = input.nextElementSibling.nextElementSibling
            # not for the leader key
            second_input.previousElementSibling.classList.remove 'hidden'
            second_input.classList.remove 'hidden'
            second_input.value =
              bindings[evt.keyCode] or (String.fromCharCode evt.keyCode)
            second_input.dataset.key = evt.keyCode
            input.blur()
            keyHeldDown = 0

      input.addEventListener 'keyup', (evt) ->
        if evt.keyCode == keyHeldDown
          keyHeldDown = 0
        if input.nextElementSibling
          input.nextElementSibling.classList.add 'hidden'
          input.nextElementSibling.nextElementSibling.classList.add 'hidden'



window.saveInputs = ->
  console.log "registering input"
  # console.log [input, (second = input.nextElementSibling?.nextElementSibling),
  #     second?.nextElementSibling.nextElementSibling]
  # console.log input.id

  # every input with an id is a command
  inputs = (inp for inp in document.getElementsByTagName('input') when inp.id)

  # for every input that is hidden, clear the dataset.key
  for empty_input in document.getElementsByTagName('input')
    console.log empty_input.classList.contains('hidden')
    if empty_input.classList.contains('hidden')
      delete empty_input.dataset.key
      empty_input.value = ''

  for cmd_input in inputs
    commands[cmd_input.id] =
      [cmd_input.dataset.key,
       (second = cmd_input.nextElementSibling?.nextElementSibling)?.dataset.key,
       second?.nextElementSibling.nextElementSibling.dataset.key]



syncInputs = () ->
  chrome.storage.sync.set commands, ->

resizeInput = (input) ->
  input?.size = input.value.length

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
