module Tracker exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Html.App         as App
import Aliases          exposing (..)
import List             exposing (map, map2, repeat, length, append, head, tail)
import Maybe            exposing (withDefault, Maybe)
import String           exposing (uncons)
import Dict             exposing (fromList, Dict, get)
import Util             exposing (numberToHexString, trimZeros)
import TrackerComponents exposing (..)
import TrackerTypes exposing (..)
import Array 
import Debug


update : Msg -> Model -> Model
update message model =
  case message of
    UpdateCell ri ci newContent ->
      model

    _ ->
      model

view : Model -> Html Msg
view {data, radix, sheetName} =
  toCells data
  |>map (rowView sheetName radix)
  |>div [ class "tracker" ]


-- Tracker data formatting

toCells : List Row -> List Cells
toCells t =
  map2 rowToCells t [ 0 .. length t ]

rowToCells : Row -> Int -> Cells
rowToCells r i =
  map2 (columnToCell i) r [ 0 .. 8 ]

columnToCell : Index -> String -> Index -> Cell
columnToCell ri content ci =
  Cell ri ci content


