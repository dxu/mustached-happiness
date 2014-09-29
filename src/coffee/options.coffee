keyHeldDown = 0

document.onreadystatechange =  () ->
  switch (state = document.readyState)
    # when 'interactive'
    when 'complete'
      init()

init = ->
  console.log @
  @commands = chrome.extension.getBackgroundPage().commands
  readied()

readied = ->
  document.getElementById('save').addEventListener 'click', (evt) ->
    saveInputs()
  document.getElementById('undo').addEventListener 'click', (evt) ->
  for key, value of commands
    node = document.getElementById key
    node_arr = [node, node.nextElementSibling?.nextElementSibling,
      node.nextElementSibling?.nextElementSibling]
    for el, index in value when el

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

saveInputs = ->
  # every input with an id is a command
  inputs = (inp for inp in document.getElementsByTagName('input') when inp.id)

  # for every input that is hidden, clear the dataset.key
  for empty_input in document.getElementsByTagName('input')
    if empty_input.classList.contains('hidden')
      delete empty_input.dataset.key
      empty_input.value = ''

  for cmd_input in inputs

    # # push the first
    # if cmd_input.dataset.key then commands[cmd_input.id].push(cmd_input.dataset.key)

    commands[cmd_input.id] =
      [cmd_input.dataset.key,
       (second = cmd_input.nextElementSibling?.nextElementSibling)?.dataset.key,
       second?.nextElementSibling.nextElementSibling.dataset.key]

  # remove null elements

  # sync to cloud
  syncInputs()





# generalized div for a command input
generateInputTemplate = (keyCode) ->
  return "<input size='1' value='#{bindings[el] or (String.fromCharCode el)}'/>  <span class='separator'>+</span>"

generateCommandTemplate = (command) ->
  return "<div id='#{command}'></div>"

syncInputs = () ->
  # notify the extensions.coffee
  chrome.storage.sync.set commands, =>
    chrome.extension.getBackgroundPage().syncCommands(@commands)


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
