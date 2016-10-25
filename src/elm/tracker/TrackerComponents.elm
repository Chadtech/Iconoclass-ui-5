module TrackerComponents exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Aliases          exposing (..)
import TrackerTypes     exposing (..)
import Maybe            exposing (withDefault, Maybe)
import Util             exposing (numberToHexString, trimZeros)
import Dict             exposing (Dict, get)
import List             exposing (map, length, head)
import Array            exposing (fromList)
import Dummies          exposing (dummyCell)


-- ###### Tracker Header
-- #####################

trackerHeader : Model -> Html Msg
trackerHeader tracker =
  div
  [ class "row" ]
  [ div
    [ class "column" ]
    [ p
      [ class "point" ]
      [ text "radix"]
    ]
  , div
    [ class "column" ]
    [ input
      [ class "field"
      , value tracker.radixField
      , onInput UpdateRadix
      ]
      []
    ]
  , div
    [ class "column wide" ]
    [ input
      [ class "field wide"
      , value tracker.sheet.name
      , onInput UpdateSheetName
      ]
      []

    ]
  ]


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
  head >> dummyCell >> .ri

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