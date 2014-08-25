console.log ' hello extension'

windows = []
wIndex = 0

#
#holds positions of pinned tabs
#
# {
#   id: {
#     incognito:
#       window:
#       tab:
#     position:
#       window: tab
#   }
# }
pTable = {}


###
# @param window the window to check
# @return boolean if the window is a valid window for movement
###
checkWindow = (window) ->
  return window.type == 'normal' and !window.incognito

chrome.windows.getAll populate: false, (winds) ->
  console.log 'hello'
  console.log  winds
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
  console.log "onRemoved", window
  console.log windows
  for window, index in windows
    if window.id == windowId
      windows.splice index, 1
  console.log windows
  console.log wIndex

chrome.runtime.onMessage.addListener ({command, data}, sender, sendResponse) ->
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
      console.log windows
      console.log wIndex

      data =
        index: -1
        windowId: windows[wIndex].id

      # if this next window is equal to the window in the position
      # then make sure it goes to the previous
      if data.windowId == pTable[tab.id]?.position.window
        data.index = pTable[tab.id]?.position.tab

      chrome.tabs.move tab.id, data, (tab) ->
        console.log tab
        chrome.tabs.update tab.id, active: true, (tab) ->
          console.log 'move down'
        chrome.windows.update windows[wIndex].id, focused: true, (tab) ->
          console.log 'move down'

        pTable[tab.id] = position:
          window: tab.windowId
          tab: tab.index

    when "move up"
      console.log "move up"
      console.log windows
      console.log wIndex

      data =
        index: -1
        windowId: windows[wIndex = (wIndex + 1) % windows.length].id

      if data.windowId == pTable[tab.id]?.position.window
        data.index = pTable[tab.id]?.position.tab

      chrome.tabs.move tab.id, data, (tab) ->
        console.log tab
        chrome.tabs.update tab.id, active: true, (tab) ->
          console.log 'move up'
        chrome.windows.update windows[wIndex].id, focused: true, (tab) ->
          console.log 'move up'

        pTable[tab.id] = position:
          window: tab.windowId
          tab: tab.index

    when "pin"
      console.log "pin"

      # if pinned, return to previous index
      if !tab.pinned
        pTable[tab.id] = position: {}
        pTable[tab.id].position[tab.windowId] = tab.index

      chrome.tabs.update tab.id, pinned: !tab.pinned, (newTab) ->
        console.log 'pinned'
        console.log pTable[newTab.id]
        if !newTab.pinned
          chrome.tabs.move newTab.id, index: pTable[newTab.id].position[newTab.windowId] || -1, (tab) ->
            console.log "moved after pinning"

    when "incognito"
      console.log "incognito"

      data =
        url: tab.url

      if tab.incognito
        data.windowId = pTable[tab.id].incognito.window
        data.index = pTable[tab.id].incognito.tab
        # if new tab is not incognito, move it to the old position
        chrome.tabs.create data,
          (newTab) ->

      else
        data.incognito = !tab.incognito
        # if caller is not incognito, create a new incognito tab with the starter url
        chrome.windows.create data,
          (newWindow) ->
            newTab = newWindow.tabs[0]
            # return to previous index in previous window
            pTable[newTab.id] = incognito:
              tab: tab.index
              window: tab.windowId

      # remove the current tab
      chrome.tabs.remove tab.id
    when "move num"
      chrome.tabs.move tab.id, index: data.tabIndex, (tab) ->
        console.log tab
      console.log data

