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
    when 65
      console.log "s"



sendMessage = (data) ->
  chrome.runtime.sendMessage data, (response) ->
    console.log "Sent Response", response



