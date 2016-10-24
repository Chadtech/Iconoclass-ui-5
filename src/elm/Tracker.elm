module Tracker exposing (trackerView)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Html.App         as App
import Types            exposing (..)
import List             exposing (map, map2, repeat, length, append, head, tail)
import Maybe            exposing (withDefault, Maybe)
import String           exposing (uncons)
import Dict             exposing (fromList, Dict, get)
import Util             exposing (numberToHexString, trimZeros)



trackerView : Tracker  -> Html Msg
trackerView {data, radix} =
  toCells data
  |>map (rowView radix)
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



-- ####### Row
-- ########### 

rowView : Radix -> Cells -> Html Msg
rowView r columns =
  let i' = formatRowIndex r columns in
  map columnView columns
  |>(::) (rowIndexView i')
  |>div [ class "row" ]

-- row formatting

formatRowIndex : Radix -> Cells -> String
formatRowIndex r row =
  let n = getRowIndex row in
  radixToString (n % r)
  |>(++) (toString (n // r))
  |>trimZeros

getRowIndex : Cells -> Index
getRowIndex =
  head >> dummyCell >> .ri

dummyCell : Maybe Cell -> Cell
dummyCell =
  withDefault
  { ri = 99, ci = 99, content = "DUMMY CELL" }

radixToString : Index -> String
radixToString ri =
  get ri numberToHexString
  |>withDefault "z"

-- 

rowIndexView : String -> Html Msg
rowIndexView indexString =
  div
  [ class "column index" ]
  [ p
    [ class "index-cell" ]
    [ text indexString ]
  ]



-- ####### Column
-- ##############

columnView : Cell -> Html Msg
columnView {ri, ci, content} =
  let
    subclass = 
      if content == "" then ""
      else " highlight"
  in
  div
  [ class ("column" ++ subclass) ]
  [ input 
    [ class ("cell" ++ subclass)
    , value content 
    , onInput (UpdateCell ri ci)
    ] 
    [] 
  ]
