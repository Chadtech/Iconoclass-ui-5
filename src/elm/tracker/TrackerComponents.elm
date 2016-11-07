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


--          ROW


rowView : String -> Radix -> Cells -> Html Msg
rowView sheetName r columns =
  let i' = formatRowIndex r columns in
  map (columnView r sheetName) columns
  |>(::) (rowIndexView i')
  |>div [ class "row" ]

rowIndexView : String -> Html Msg
rowIndexView indexString =
  div
  [ class "column index" ]
  [ p
    [ class "index-cell" ]
    [ text indexString ]
  ]


--        ROW FORMATTING


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


--          COLUMN


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

columnIndexView : Int -> Html Msg
columnIndexView i =
  div
  [ class "column index" ]
  [ p 
    [ class "index-cell" ]
    [ text (toString i) ] 
  ]