import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Init             exposing (initialModel)
import TrackerTypes
import Tracker
import Dict             exposing (Dict, map, get, insert, remove)
import Aliases          exposing (..)
import Maybe            exposing (withDefault)
import Dummies          exposing (dummyTracker, errorSheet)
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
      { model 
      | sheets =
          insert name sheet model.sheets
      }
      |>update SyncTrackers

    UpdateSheetName oldName sheet ->
      packModel
      { model
      | sheets =
          remove oldName model.sheets
          |>insert sheet.name sheet
      , trackerModels = 
          map (fixNames oldName sheet) model.trackerModels
      }



    SyncTrackers ->
      packModel
      { model 
      | trackerModels =
          model.trackerModels
          |>map (syncTracker model.sheets)
      }

    NoOp -> packModel model


fixNames : String -> Sheet -> String -> TrackerTypes.Model -> TrackerTypes.Model
fixNames oldName sheet _ tracker =
  if tracker.sheet.name == oldName then
    { tracker | sheet = sheet }
  else tracker
        
syncTracker : Dict String Sheet -> String -> TrackerTypes.Model -> TrackerTypes.Model
syncTracker sheets _ tracker =
  { tracker 
  | sheet = 
      get tracker.sheet.name sheets
      |>withDefault errorSheet
  }

updateTracker : String -> TrackerTypes.Msg -> Model -> (TrackerTypes.Model, Msg)
updateTracker name tMsg {trackerModels} =
  get name trackerModels
  |>withDefault dummyTracker
  |>Tracker.update tMsg


packModel : Model -> (Model, Cmd Msg) 
packModel m =
  (m, Cmd.none)



