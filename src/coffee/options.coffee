
document.onreadystatechange =  () ->
  switch (state = document.readyState)
    when 'interactive'
      init()
    when 'complete'
      readied()

init = ->
readied = ->
  inputs = document.getElementsByTagName('input')
  console.log inputs
  for input in inputs
    do (input) ->
      input.addEventListener 'keydown', (evt) ->
        console.log 'keydown', input
        input.value = ''
      input.addEventListener 'keyup', (evt) ->
        console.log 'keyup', String.fromCharCode evt.keyCode
        input.value = ''


