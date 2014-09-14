commands =
  "leader":     [220]           # \
  "move-left":  [17, 65]   # CTRL + a
  "move-right": [17, 68]   # CTRL + d
  "move-down":  [17, 69]   # CTRL + s
  "move-up":    [17, 81]   # CTRL + w
  "extract":    [17, 83]   # CTRL + e
  "pin":        [17, 80]   # CTRL + p
  "incognito":  [17, 73]   # CTRL + i
  "options":    [16, 191]  # SHIFT + /
  "move-num":   [[17, 48], [17, 49], [17, 50], [17, 51], [17, 52], [17, 53], [17, 54], [17, 55], [17, 56], [17, 57]]        # CTRL

cData =
  "default": -> {}
  "move-num": (input, evt) ->
    return tabIndex: evt.keyCode - 49

isArray = (arr) ->
  Object.prototype.toString.call(arr) == '[object Array]'

# if null, then nothing to compare
getHeldComparison = (input) ->
  if (check = input[0]) and input.length == 2
    # if 2 keys, check first key. If it's equal to leader, check leader. Else check held key
    if heldKey != input[0]
      # if not, then just return null
      return null
    check = input[1]
  return check


# input is the input
send = (command, input, evt) ->
  console.log command, input, evt, getHeldComparison(input)
  # if the type of element one is an array, that means there are multiple accepted inputs
  if isArray input[0]
    # loop through each of the inputs and set check
    unless (inp for inp in input when evt.keyCode == getHeldComparison(inp)).length
      return
  else
    unless evt.keyCode == getHeldComparison(input)
      return

  data = {}
  sendMessage
    command: command
    data: (cData[command] || cData.default)(input, evt)


# connect to the port
port = chrome.runtime.connect name: "commands"
port.onMessage.addListener (msg) ->
  console.log msg
  if(msg.commands)
    commands = msg.commands

escape = false

heldKey = 0

window.onkeyup = (evt) ->
  # if evt.keycode is the heldkey, clear the held key
  if evt.keyCode == heldKey
    heldKey = 0

window.addEventListener 'keydown', (evt) ->

  # don't do it if focus is on an input box
  activeElement = document.activeElement.tagName.toLowerCase()

  if activeElement == "input" or activeElement == "textarea" then return

  data = {}

  if heldKey == 0
    heldKey = evt.keyCode

  # set the data to send over
  switch (keyCode = evt.keyCode)
    when 48, 49, 50, 51, 52, 53, 54, 55, 56, 57
      data =
        data:
          tabIndex: evt.keyCode - 49

  for key, value of commands
    send key, value, evt, data

sendMessage = (data) ->
  chrome.runtime.sendMessage data, ->
