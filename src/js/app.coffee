_         = require 'lodash'
Elm       = require './elm.js'
app       = Elm.Main.fullscreen()
remote    = get 'remote'
fs        = get 'fs'
dialog    = remote.require 'dialog'


{save, open, focus} = app.ports


focus.subscribe (payload) ->
  console.log payload

  metaKeyDown = payload[0]
  dataIndices = payload[1]
  direction   = payload[2]

  indices = dataIndices.split '-'
  tracker = indices[0]
  ri      = parseInt indices[1], 10
  ci      = parseInt indices[2], 10


  switch direction
    when "left"
      if metaKeyDown
        ci = ci - 2
      else
        ci--
    when "right"
      if metaKeyDown
        ci = ci + 2
      else
        ci++
    when "down"
      if metaKeyDown
        ri = ri + 10
      else
        ri++
    when "up"
      if metaKeyDown
        ri = ri - 10
      else
        ri--
    when "enter"
      ri++

  newDataIndices = [ tracker, ri, ci ].join '-'

  query = "[data-index=" + newDataIndices + "]"

  el = (document.querySelectorAll query)[0]

  el.focus() if el?



justFileName = (filePath) ->
  i = filePath.length - 1
  i-- until filePath[i] is '/'
  noDirectory = filePath.slice i + 1
  noDirectory.slice 0, (noDirectory.length - 4)



open.subscribe (trackerName) ->

  options = 
    properties: [
      'multiSelections'
      'openFile'
      'openDirectory'
    ]

  dialog.showOpenDialog options, (filePaths) ->
    filePaths = _.filter filePaths, (fp) ->
      '.scr' is fp.slice fp.length - 4

    sheets = _.map filePaths, (filePath) ->
      csv  = fs.readFileSync filePath, 'utf-8'
      csv  = csv.split '\n'

      data = _.map csv, (col) -> col.split ','

      data:   data 
      name:   justFileName filePath
      width:  data[0].length
      height: data.length

    app.ports.openSheets.send sheets


save.subscribe (payload) ->
  {sheet, directory} = payload

  writeFile = (directory) ->
    # Stringify Rows
    data = _.map sheet.data, (row) ->
      row.join ','

    # Stringify document
    data = data.join '\n'

    fileName = 
      directory + 
      '/' + 
      sheet.name +
      '.scr'

    fs.writeFileSync fileName, data

  if directory is ""
    dialog.showSaveDialog (filePath) =>
      return unless filePath?

      # Get just the directory
      # and ignore the file name
      i = filePath.length - 1
      i-- until filePath[i] is '/'
      filePath = filePath.slice 0, i

      app.ports.setDirectory.send filePath

      writeFile filePath
  else
    writeFile directory


