console.log " hello scripts "

escape = false

window.onkeyup = (evt) ->
  switch evt.keyCode
    when 220
      console.log "escape"
      escape = true
      setTimeout (-> escape = false), 500
    when 68
      console.log "d"
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'move right'
    when 65
      console.log "a"
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'move left'
    when 83
      console.log "s"
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'extract'
    when 81
      console.log "q"
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'move down'
    when 69
      console.log "e"
      if evt.ctrlKey
        evt.preventDefault()
        sendMessage command: 'move up'
    when 80
      console.log "p"
      if evt.ctrlKey
        console.log "po"
        evt.preventDefault()
        sendMessage command: 'pin'
    when 73
      console.log "i"
      if evt.ctrlKey
        console.log "po"
        evt.preventDefault()
        sendMessage command: 'incognito'

sendMessage = (data) ->
  chrome.runtime.sendMessage data, (response) ->
    console.log "Sent Response", response
