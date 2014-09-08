console.log 'hello wc'
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

commandsWithData =
  "move-num":   [17]        # CTRL


send = (command, input, keyCode, data={}) ->
  console.log 'in send', command, input, keyCode, heldKey
  if (check = input[0]) and input.length == 2
    # if 2 keys, check first key. If it's equal to leader, check leader. Else check held key
    if heldKey != input[0]
      # if not, then just return
      return
    check = input[1]
  data = {}
  console.log check
  if check == keyCode
    console.log 'sent', command, input, keyCode
    sendMessage
      command: command
      data: data


# connect to the port
port = chrome.runtime.connect name: "commands"
port.onMessage.addListener (msg) ->
  # console.log 'onmessage', msg
  # if msg.question == "Who's there?"
  #   port.postMessage answer: "Madame"
  # else if msg.question == "Madame who?"
  #   port.postMessage({answer: "Madame... Bovary"})

escape = false

heldKey = 0

window.onkeyup = (evt) ->
  # console.log 'keyup'
  # if evt.keycode is the heldkey, clear the held key
  if evt.keyCode == heldKey
    heldKey = 0

window.addEventListener 'keydown', (evt) ->
  console.log evt
  # console.log 'keypress'

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


  # console.log 'hit first', commands
  for key, value of commands
    # console.log 'hit', value, key, evt.keyCode
    send key, value, evt.keyCode, data

  # switch evt.keyCode
  #   # escape
  #   when 220
  #     escape = true
  #     setTimeout (-> escape = false), 500
  #   # a
  #   when 65
  #     if evt.ctrlKey
  #       evt.preventDefault()
  #       sendMessage command: 'move left'
  #   # d
  #   when 68
  #     if evt.ctrlKey
  #       evt.preventDefault()
  #       sendMessage command: 'move right'
  #   # q
  #   when 81
  #     if evt.ctrlKey
  #       evt.preventDefault()
  #       sendMessage command: 'move down'
  #   # e
  #   when 69
  #     if evt.ctrlKey
  #       evt.preventDefault()
  #       sendMessage command: 'move up'
  #   # s
  #   when 83
  #     if evt.ctrlKey
  #       evt.preventDefault()
  #       sendMessage command: 'extract'
  #   # p
  #   when 80
  #     if evt.ctrlKey
  #       evt.preventDefault()
  #       sendMessage command: 'pin'
  #   # i
  #   when 73
  #     if evt.ctrlKey
  #       evt.preventDefault()
  #       sendMessage command: 'incognito'
  #   # numbers 0 - 9
  #   when 48, 49, 50, 51, 52, 53, 54, 55, 56, 57
  #     # subtract 49: -1 will got to the final
  #     if evt.ctrlKey
  #       evt.preventDefault()
  #       sendMessage
  #         command: "move num"
  #         data:
  #           tabIndex: evt.keyCode - 49



sendMessage = (data) ->
  chrome.runtime.sendMessage data, ->
