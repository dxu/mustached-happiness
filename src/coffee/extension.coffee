console.log ' hello extension'

windows = []
wIndex = 0

###
# @param window the window to check
# @return boolean if the window is a valid window for movement
###
checkWindow = (window) ->
  return window.type == 'normal' and window.state == 'normal'

chrome.windows.getAll populate: false, (winds) ->
  # take only the windows that are normal
  windows = (window for window in winds when checkWindow window)

chrome.windows.getCurrent populate:false, (window) ->
  wIndex = i for w, i in windows when window.id == w.id
  console.log windows
  console.log wIndex

chrome.windows.onCreated.addListener (window) ->
  if checkWindow window then windows.push window
  console.log "onCreated", window
  console.log windows
  console.log wIndex

chrome.windows.onRemoved.addListener (windowId) ->
  for window, index in windows
    if window.id == windowId
      windows.splice index, 1
  console.log "onRemoved", window
  console.log windows
  console.log wIndex

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
        windowId:  windows[wIndex].id,
        (tab) ->
          console.log tab
          chrome.tabs.update tab.id, active: true, (tab) ->
            console.log 'fixed'
          chrome.windows.update windows[wIndex].id, focused: true, (tab) ->
            console.log 'fixed'

    when "move up"
      console.log "move up"
      console.log wIndex
      chrome.tabs.move tab.id,
        index: -1
        windowId: windows[wIndex = (wIndex + 1) % windows.length].id,
        (tab) ->
          console.log tab
          chrome.tabs.update tab.id, active: true, (tab) ->
            console.log 'fixed'
          chrome.windows.update windows[wIndex].id, focused: true, (tab) ->
            console.log 'fixed'

