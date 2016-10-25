module View exposing (..)

import Html             exposing (..)
import Html.App
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Tracker
import TrackerTypes
import Aliases exposing (..)
import List    exposing (map, map2, repeat)
import Dict    exposing (Dict, toList, get)
import Maybe   exposing (withDefault)
import Dummies exposing (blankSheet, dummyTracker)

leftMiddleRight : List String
leftMiddleRight =
  [ "left", "middle", "right"]

view : Model -> Html Msg
view model = 
  div
  [ class "main" ]
  (renderTrackers model)

renderTrackers : Model -> List (Html Msg)
renderTrackers model  =
  leftMiddleRight
  |>map (render model)
  |>map2 linkTrackerView leftMiddleRight

render : Model -> String -> Html TrackerTypes.Msg
render {sheets, trackerModels} =
  orderTrackers trackerModels 
  >> setSheet sheets
  >> Tracker.view


setSheet : Dict String Sheet -> TrackerTypes.Model -> TrackerTypes.Model
setSheet sheets t = 
  { t 
  | sheet = 
      get t.sheet.name sheets
      |>withDefault blankSheet
  }


linkTrackerView : String -> Html TrackerTypes.Msg -> Html Msg
linkTrackerView name html =
  Html.App.map (TrackerMsg name) html

orderTrackers : Dict String TrackerTypes.Model -> String -> TrackerTypes.Model
orderTrackers models name =
  get name models
  |>withDefault dummyTracker


