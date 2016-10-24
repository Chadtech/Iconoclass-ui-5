import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Init             exposing (initialModel)
import TrackerTypes
import Tracker
import Dict             exposing (get)
import Maybe            exposing (withDefault)
import Debug exposing (log)

main =
  App.program
  { init          = (initialModel, Cmd.none) 
  , view          = view
  , update        = update
  , subscriptions = subscriptions
  }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    TrackerMsg name tMsg ->
      let 
        tracker' = 
          get name model.trackerModels
          |>withDefault dummyTracker
          |>Tracker.update tMsg

      in
      (model, Cmd.none)

dummyTracker : TrackerTypes.Model
dummyTracker =
  { radix = 16
  , data  = [ [ "ERROR" ] ]
  , sheetName = "NOPE"
  }





