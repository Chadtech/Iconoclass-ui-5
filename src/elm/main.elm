import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Init             exposing (initialModel)
import TrackerTypes
import Tracker
import Dict             exposing (get, insert)
import Maybe            exposing (withDefault)
import Dummies          exposing (dummyTracker, blankSheet)

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
        (tracker', message') = 
          updateTracker name tMsg model
      in
      { model
      | trackerModels =
          insert name tracker' model.trackerModels
      }
      |>update message'

    UpdateSheet sheet ->
      let {name} = sheet in
      packModel
      { model 
      | sheets =
          insert name sheet model.sheets
      }

    NoOp -> packModel model
        

updateTracker : String -> TrackerTypes.Msg -> Model -> (TrackerTypes.Model, Msg)
updateTracker name tMsg {trackerModels} =
  get name trackerModels
  |>withDefault dummyTracker
  |>Tracker.update tMsg


packModel : Model -> (Model, Cmd Msg) 
packModel m =
  (m, Cmd.none)



