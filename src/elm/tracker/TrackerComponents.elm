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

columnNumbers : List ColumnModel -> Html Msg
columnNumbers columns =
  map columnIndexView columns
  |>(::) (div [ class "column index" ] [])
  |>div [ class "row" ]


--          ROW


rowView : Radix -> Cells -> Html Msg
rowView r columns =
  let i' = formatRowIndex r columns in
  map (columnView r) columns
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


columnView : Radix -> Cell -> Html Msg
columnView radix {ri, ci, content} =
  let
    subclass = 
      if content == "" then 
        if ri % radix /= 0 then ""
        else
          " zero-row"
      else " highlight"
  in
  div
  [ class ("column" ++ subclass) ]
  [ input 
    [ class ("cell " ++ subclass)
    , value content 
    , onInput (UpdateCell ri ci)
    ] 
    [] 
  ]

columnIndexView : ColumnModel -> Html Msg
columnIndexView {index, show} =
  let
    child = 
      if show then
        div
        [ class "drop-down narrow" ]
        [ columnOptions
        ]
      else
        p 
        [ class "index-cell" ]
        [ text (toString index) ] 

    subclass =
      if show then
        "clean"
      else
        "index"

  in
  div
  [ class ("column " ++ subclass) 
  , onMouseOver (ColumnIndexMouseOver index)
  , onMouseOut (ColumnIndexMouseOut index)
  ]
  [ child ]

columnOptions : Html Msg
columnOptions =
  div
  [ class "column-options" ]
  [ input 
    [ class "column-button close"
    , type' "submit"
    , value "x"
    ]
    []
  , input 
    [ class "column-button"
    , type' "submit"
    , value ">"
    ]
    []
  ]



