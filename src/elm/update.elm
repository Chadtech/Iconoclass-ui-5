module Update exposing (update)

import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Init             exposing (initialModel)
import TrackerTypes
import Tracker
import Dict             exposing (Dict, map, get, insert, remove, keys, values)
import List             exposing (head)
import Aliases          exposing (..)
import Maybe            exposing (withDefault)
import Dummies          exposing (dummyTracker, errorSheet, blankSheet)


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
      { model
      | sheets =
          remove oldName model.sheets
          |>insert sheet.name sheet
      , trackerModels = 
          map (fixNames oldName sheet) model.trackerModels
      }
      |>update SyncTrackers

    SyncTrackers ->
      let {trackerModels, sheets} = model in
      packModel
      { model 
      | trackerModels =
          trackerModels
          |>map (syncTracker sheets)
      }

    NewSheet newSheetName ->
      let {sheets} = model in
      { model
      | sheets =
          insert 
            newSheetName 
            (newSheet newSheetName)
            sheets
      }
      |>update SyncTrackers

    RemoveSheet name ->
      let
        newSheets = 
          remove name model.sheets
      in
      { model 
      | sheets = newSheets
      , trackerModels =
          let
            firstSheet =
              head (values newSheets)
              |>withDefault errorSheet
          in
          map (fixNames name firstSheet) model.trackerModels
      }
      |>update SyncTrackers

      
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
  , otherSheets = keys sheets
  }

updateTracker : String -> TrackerTypes.Msg -> Model -> (TrackerTypes.Model, Msg)
updateTracker name tMsg {trackerModels} =
  get name trackerModels
  |>withDefault dummyTracker
  |>Tracker.update tMsg

packModel : Model -> (Model, Cmd Msg) 
packModel m =
  (m, Cmd.none)



