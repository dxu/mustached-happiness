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

    when "move down"
      console.log "move down"
      wIndex = if (wIndex - 1) < 0 then windows.length - 1 else wIndex - 1
      chrome.tabs.move tab.id,
        index: -1
        window:  windows[windex].id,
        (tab) ->
          console.log tab

    when "move up"
      console.log "move up"
      console.log wIndex
      chrome.tabs.move tab.id,
        index: -1
        window: windows[wIndex = (wIndex + 1) % windows.length].id,
        (tab) ->
          console.log tab

