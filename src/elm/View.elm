module View exposing (..)

import Html             exposing (..)
import Html.App
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import TrackerView as Tracker
import TrackerTypes
import Aliases exposing (..)
import List    exposing (map, map2)
import Dict    exposing (Dict, get)
import Maybe   exposing (withDefault)
import Dummies exposing (dummyTracker)


view : Model -> Html Msg
view model = 
  div
  [ class "main" ]
  (renderTrackers model)

leftMiddleRight : List String
leftMiddleRight =
  [ "left", "middle", "right"]

renderTrackers : Model -> List (Html Msg)
renderTrackers model  =
  leftMiddleRight
  |>map (render model)
  |>map2 linkTrackerView leftMiddleRight

render : Model -> String -> Html TrackerTypes.Msg
render {sheets, trackerModels} =
  orderTrackers trackerModels >> Tracker.view

linkTrackerView : String -> Html TrackerTypes.Msg -> Html Msg
linkTrackerView name html =
  Html.App.map (TrackerMsg name) html

orderTrackers : Dict String TrackerTypes.Model -> String -> TrackerTypes.Model
orderTrackers models name =
  get name models
  |>withDefault dummyTracker


