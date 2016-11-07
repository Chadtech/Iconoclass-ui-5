_         = require 'lodash'
Elm       = require './elm.js'
app       = Elm.Main.fullscreen()
{save} = app.ports

respond = (thing) ->
  app.ports.response.send thing

save.subscribe (sheet) ->
  console.log "SHEET", sheet

