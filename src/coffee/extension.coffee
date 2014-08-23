console.log ' hello extension'


chrome.runtime.onMessage.addListener ({command}, sender, sendResponse) ->
  {tab} = sender
  switch command
    when "move left"
      console.log "move left"
      chrome.tabs.move tab.id, index: tab.index - 1, (tab) ->
        console.log tab


    when "move right"
      console.log "move right"
      chrome.tabs.move tab.id, index: tab.index + 1, (tab) ->
        console.log tab

    when "extract"
      console.log "extract"
      chrome.windows.create {tabId: tab.id}, (window) ->
        console.log window
