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
  [ column
    [ p
      [ class "point ignorable" ]
      [ text "radix"]
    ]
  , column
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
  , columnClean
    [ input
      [ class "button"
      , type' "submit"
      , value "new"
      , onClick NewSheet
      ]
      []
    ]
  , columnClean
    [ input
      [ class "button"
      , type' "submit"
      , value "open"
      ]
      []
    ]
  , columnClean
    [ input
      [ class "button"
      , type' "submit"
      , value "save"
      ]
      []
    ]
  , columnClean
    [ input
      [ class "button"
      , type' "submit"
      , value "close"
      ]
      []
    ]
  , div
    [ class "column wide index" ]
    [ dropdown tracker ]
  ]


--        DROPPED DOWN


dropdown : Model -> Html Msg
dropdown tracker =
  let {droppedDown} = tracker in
  if droppedDown then
    down tracker
  else
    up tracker

up : Model -> Html Msg
up tracker =
  p 
  [ class "index-cell" 
  , onClick DropDown
  ]
  [ text tracker.sheet.name ]

down : Model -> Html Msg
down {otherSheets} =
  div
  [ class "dropped-down" ]
  (map downOption otherSheets)


downOption : String -> Html Msg
downOption str =
  div 
  [ class "drop-down-option" ]
  [ p 
    [ class "index-cell" 
    , onClick (SetSheet str)
    ] 
    [ text str ]
  ]


--          COLUMN


column : List (Html Msg) -> Html Msg
column = div [ class "column" ]

columnClean : List (Html Msg) -> Html Msg
columnClean = div [ class "column clean" ]

columnNumbers : Sheet -> Html Msg
columnNumbers {width} =
  map columnIndexView [ 0 .. (width - 1) ]
  |>(::) (div [ class "column index" ] [])
  |>div [ class "row" ]


-- ####### Row
-- ########### 

rowView : String -> Radix -> Cells -> Html Msg
rowView sheetName r columns =
  let i' = formatRowIndex r columns in
  map (columnView r sheetName) columns
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

columnIndexView : Int -> Html Msg
columnIndexView i =
  div
  [ class "column index" ]
  [ p 
    [ class "index-cell" ]
    [ text (toString i) ] 
  ]



-- ####### Column
-- ##############

columnView : Radix -> String -> Cell -> Html Msg
columnView radix sheetName {ri, ci, content} =
  let
    highlight = 
      if content == "" then ""
      else " highlight"

    zeroClass =
      if ri % radix /= 0 then ""
      else " zero-row"

    subclass = 
      highlight ++ zeroClass
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