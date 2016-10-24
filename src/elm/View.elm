module View exposing (..)

import Html             exposing (..)
import Html.App
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Tracker
import List    exposing (map, map2)
import Dict    exposing (Dict, toList, get)
import Maybe   exposing (withDefault)

leftMiddleRight : List String
leftMiddleRight =
  [ "left", "middle", "right"]

view : Model -> Html Msg
view {sheets, trackerModels} = 
  div
  [ class "main" ]
  (getTrackers trackerModels)

dummyTracker : Tracker.Model
dummyTracker =
  { radix = 16
  , data  = [ [ "ERROR" ] ]
  , sheetName = "NOPE"
  }

getTrackers : Dict String Tracker.Model -> List (Html Msg)
getTrackers trackerModels =
  map 
    (getTrackerModel trackerModels) 
    leftMiddleRight
  |>map Tracker.view
  |>map2 linkTrackerView leftMiddleRight

linkTrackerView : String -> Html Tracker.Msg -> Html Msg
linkTrackerView name html =
  Html.App.map (TrackerMsg name) html

getTrackerModel : Dict String Tracker.Model -> String -> Tracker.Model
getTrackerModel models name =
  get name models
  |>withDefault dummyTracker


