# connect to the port
port = chrome.runtime.connect name: "commands"
port.onMessage.addListener (msg) ->
  console.log 'onmessage', msg
  # if msg.question == "Who's there?"
  #   port.postMessage answer: "Madame"
  # else if msg.question == "Madame who?"
  #   port.postMessage({answer: "Madame... Bovary"})

escape = false

window.onkeyup = (evt) ->

  # don't do it if focus is on an input box
  activeElement = document.activeElement.tagName.toLowerCase()

  if activeElement == "input" or activeElement == "textarea" then return

  switch evt.keyCode
    # escape
    when 220
      escape = true
      setTimeout (-> escape = false), 500
    # a
    when 65
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'move left'
    # d
    when 68
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'move right'
    # q
    when 81
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'move down'
    # e
    when 69
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'move up'
    # s
    when 83
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'extract'
    # p
    when 80
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'pin'
    # i
    when 73
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'incognito'
    # numbers 0 - 9
    when 48, 49, 50, 51, 52, 53, 54, 55, 56, 57
      # subtract 49: -1 will got to the final
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage
          command: "move num"
          data:
            tabIndex: evt.keyCode - 49



sendMessage = (data) ->
  chrome.runtime.sendMessage data, ->
