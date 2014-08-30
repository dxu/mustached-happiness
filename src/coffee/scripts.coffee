
escape = false

window.onkeyup = (evt) ->

  # don't do it if focus is on an input box

  if document.activeElement.tagName.toLowerCase() == "input" then return

  switch evt.keyCode
    # escape
    when 220
      escape = true
      setTimeout (-> escape = false), 500
    # d
    when 68
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'move right'
    # a
    when 65
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'move left'
    # s
    when 83
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'extract'
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
