console.log ' hello extension'


chrome.runtime.onMessage.addListener ({command}, sender, sendResponse) ->
  {tab} = sender
  switch command
    when "move left"
      console.log "move left"


    when "move right"
      console.log "move right"
