import Html
import Html.App as App
import Types    exposing (..)
import Ports    exposing (..)
import View     exposing (view)
import Init     exposing (initialModel)
import Aliases  exposing (..)
import Update   exposing (update)

main =
  App.program
  { init          = (initialModel, Cmd.none) 
  , view          = view
  , update        = update
  , subscriptions = subscriptions
  }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch 
  [ setDirectory SetDirectory

  ]
