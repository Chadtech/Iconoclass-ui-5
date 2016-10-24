module TrackerComponents exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Aliases          exposing (..)
import TrackerTypes     exposing (..)
import Maybe            exposing (withDefault, Maybe)
import Util             exposing (numberToHexString, trimZeros)
import Dict             exposing (fromList, Dict, get)
import List             exposing (map, map2, repeat, length, append, head, tail)




-- ####### Row
-- ########### 

rowView : String -> Radix -> Cells -> Html Msg
rowView sheetName r columns =
  let i' = formatRowIndex r columns in
  map (columnView sheetName) columns
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
  --Array.get

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

columnView : String -> Cell -> Html Msg
columnView sheetName {ri, ci, content} =
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