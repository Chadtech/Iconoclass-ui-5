_         = require 'lodash'
Elm       = require './elm.js'
app       = Elm.Main.fullscreen()
remote    = get 'remote'
fs        = get 'fs'
dialog    = remote.require 'dialog'


{save, open} = app.ports

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
      '.csv' is fp.slice fp.length - 4

    sheets = _.map filePaths, (filePath) ->
      csv  = fs.readFileSync filePath, 'utf-8'
      csv  = csv.split '\n'

      data = _.map csv, (col) -> col.split ','

      data: data 
      name: justFileName filePath
      width: data[0].length
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
      '.csv'

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


