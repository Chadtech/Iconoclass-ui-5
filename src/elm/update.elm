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
import List             exposing (head, foldr)
import String           exposing (split)
import Aliases          exposing (..)
import Maybe            exposing (withDefault)
import Dummies          exposing (dummyTracker, errorSheet, blankSheet)

import Debug

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
          map (fixTracker oldName sheet) model.trackerModels
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
          map (fixTracker name firstSheet) model.trackerModels
      }
      |>update SyncTrackers

    SaveSheet sheet ->
      let
        payload =
          { sheet     = sheet
          , directory = model.directory
          }
      in
      (model, save payload)

    OpenDialog trackerName ->
      (model, open trackerName)

    OpenSheets sheets ->
      { model
      | sheets =
          foldr insertSheet model.sheets sheets
      }
      |>update SyncTrackers

    SetDirectory directory ->
      ({model | directory = directory}, Cmd.none)

    HandleKeyDown dataIndices code ->
      handleKeyDown model dataIndices code

    HandleKeyUp code ->
      handleKeyUp model code

    NoOp -> packModel model


handleKeyUp : Model -> Int -> (Model, Cmd msg)
handleKeyUp model code =
  if code == 91 then
    ({ model | metaKeyDown = False }, Cmd.none)
  else
    (model, Cmd.none)


handleKeyDown : Model -> String -> Int -> (Model, Cmd msg)
handleKeyDown model dataIndices code =
  let
    bundle =
      (,,) model.metaKeyDown dataIndices

    focus_ =
      bundle >> focus
  in
  case code of
    37 -> (model, focus_ "left")
    38 -> (model, focus_ "up")
    39 -> (model, focus_ "right")
    40 -> (model, focus_ "down")
    13 -> (model, focus_ "enter")
    91 -> 
      ({ model | metaKeyDown = True }, Cmd.none)
    _  -> 
      (model, Cmd.none)


insertSheet : Sheet -> Dict String Sheet -> Dict String Sheet
insertSheet sheet sheets =
  insert sheet.name sheet sheets

fixTracker : String -> Sheet -> String -> TrackerTypes.Model -> TrackerTypes.Model
fixTracker oldName sheet _ tracker =
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



