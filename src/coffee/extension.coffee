window.commands =
  "leader":     [220]           # \
  "move-left":  [17, 65]   # CTRL + a
  "move-right": [17, 68]   # CTRL + d
  "move-down":  [17, 69]   # CTRL + s
  "move-up":    [17, 81]   # CTRL + w
  "extract":    [17, 83]   # CTRL + e
  "pin":        [17, 80]   # CTRL + p
  "incognito":  [17, 73]   # CTRL + i
  "move-num":   [17]        # CTRL
  "options":    [16, 191]  # SHIFT + /

chrome.storage.sync.get null, (items) ->
  window.commands = if items.leader then items else window.commands


window.connections = {}

window.syncCommands = (commands) ->
  window.commands = commands
  # notify all connections that come in to update their commands
  console.log 'hello m'
  for id, port of connections
    console.log 'hello'
    port.postMessage commands: commands


# setup one way port connection listener from tab to this
do setupConnection = ->
  chrome.runtime.onConnect.addListener (port) ->
    console.log 'connected', port
    connections[port.sender.tab.id] = port
    console.log connections
    # send a message to the port to update to current mappings
    port.postMessage commands: window.commands

    port.onDisconnect.addListener (port) ->
      console.log 'disconnected', port
      delete connections[port.sender.tab.id]

  # port = chrome.runtime.connect name: 'temps'
  # port.postMessage('hi')

  # chrome.runtime.onDisconnect.addListener (port) ->
  #   console.log 'discnonected', port


# holds positions of pinned tabs
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
windows = []
wIndex = 0

###
# @param window the window to check
# @return boolean if the window is a valid window for movement
###
checkWindow = (window) ->
  return window.type == 'normal' and !window.incognito

chrome.windows.getAll populate: false, (winds) ->
  # take only the windows that are normal
  windows = (window for window in winds when checkWindow window)

chrome.windows.getCurrent populate:false, (window) ->
  wIndex = i for w, i in windows when window.id == w.id

chrome.windows.onCreated.addListener (window) ->
  if checkWindow window then windows.push window

chrome.windows.onRemoved.addListener (windowId) ->
  for window, index in windows
    if window.id == windowId
      windows.splice index, 1

chrome.runtime.onMessage.addListener ({command, data}, sender, sendResponse) ->
  {tab} = sender

  switch command
    when "move-left"
      chrome.tabs.move tab.id, index: tab.index - 1, ->

    when "move-right"
      chrome.tabs.move tab.id, index: tab.index + 1, ->

    when "extract"
      chrome.windows.create {tabId: tab.id}, ->

    when "move-down"
      wIndex = if (wIndex - 1) < 0 then windows.length - 1 else wIndex - 1
      data =
        index: -1
        windowId: windows[wIndex].id

      # if this next window is equal to the window in the position
      # then make sure it goes to the previous
      #
      # if there is old position data in the ptable, then load the index
      data.index = pTable[tab.id]?.position[data.windowId] || data.index

      if pTable[tab.id]
        pTable[tab.id].position =  pTable[tab.id].position || {}
      else
        pTable[tab.id] = position: {}
      pTable[tab.id].position[tab.windowId] = tab.index

      chrome.tabs.move tab.id, data, (newTab) ->
        chrome.tabs.update newTab.id, active: true
        chrome.windows.update windows[wIndex].id, focused: true



    when "move-up"

      data =
        index: -1
        windowId: windows[wIndex = (wIndex + 1) % windows.length].id

      data.index = pTable[tab.id]?.position[data.windowId] || data.index

      if pTable[tab.id]
        pTable[tab.id].position =  pTable[tab.id].position || {}
      else
        pTable[tab.id] = position: {}
      pTable[tab.id].position[tab.windowId] = tab.index

      chrome.tabs.move tab.id, data, (newTab) ->
        chrome.tabs.update newTab.id, active: true, ->
        chrome.windows.update windows[wIndex].id, focused: true, ->



    when "pin"

      # if pinned, return to previous index
      if !tab.pinned
        if pTable[tab.id]
          pTable[tab.id].position ?= {}
        else
          pTable[tab.id] = position: {}
        pTable[tab.id].position[tab.windowId] = tab.index

      chrome.tabs.update tab.id, pinned: !tab.pinned, (newTab) ->
        if !newTab.pinned
          chrome.tabs.move newTab.id, index: pTable[newTab.id].position[newTab.windowId] || -1, ->

    when "incognito"

      data =
        url: tab.url

      if tab.incognito
        data.windowId = pTable[tab.id].incognito.window
        data.index = pTable[tab.id].incognito.tab
        # if new tab is not incognito, move it to the old position
        chrome.tabs.create data, ->

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
    when "move-num"
      # take into account the number of pinned tabs

      if data.tabIndex == -1
        chrome.tabs.update tab.id, pinned: false, (newTab) ->
          chrome.tabs.move newTab.id, index: data.tabIndex, ->

      else
        chrome.tabs.query index: data.tabIndex, (tabs) ->
          if tabs[0].pinned != tab.pinned
            chrome.tabs.update tab.id, pinned: !tab.pinned, (newTab) ->
              chrome.tabs.move tab.id, index: data.tabIndex, ->
          else
            chrome.tabs.move tab.id, index: data.tabIndex, ->



