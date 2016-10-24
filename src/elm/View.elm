module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import Tracker exposing (trackerView)
import List    exposing (map)
import Dict    exposing (toList)


view : Model -> Html Msg
view {sheets} = 
  map trackerView (toList sheets)
  |>div [ class "main" ] 
