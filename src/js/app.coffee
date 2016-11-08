_         = require 'lodash'
Elm       = require './elm.js'
app       = Elm.Main.fullscreen()
{save}    = app.ports
remote    = get 'remote'
fs        = get 'fs'
dialog    = remote.require 'dialog'


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

      app.ports.setDirectory.send(filePath)

      writeFile filePath
  else
      writeFile directory


