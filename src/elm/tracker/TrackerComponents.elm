module TrackerComponents exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Aliases          exposing (..)
import TrackerTypes     exposing (..)
import Maybe            exposing (withDefault, Maybe)
import Util             exposing (numberToHexString, trimZeros)
import Dict             exposing (Dict, get)
import List             exposing (map, map2, length, head)
import Array            exposing (fromList)
import Dummies          exposing (dummyCell)
import String           exposing (concat)
import Json.Decode      as Json


--          ROW


rowView : String -> Radix -> (Bool, Cells) -> Html Msg
rowView trackerName r (showDropDown, columns) =
  map (columnView trackerName r) columns
  |>(::) (rowIndexView r showDropDown columns)
  |>div [ class "row" ]

rowIndexView : Radix -> Bool -> Cells -> Html Msg
rowIndexView radix show cells =
  let

    (index, iStr) = 
      formatRowIndex radix cells

    child = 
      if show then
        div
        [ class "drop-down narrow" ]
        [ rowOptions index ]
      else
      p
      [ class "index-cell" ]
      [ text iStr ]

    subclass =
      if show then "clean"
      else "index"

  in
  div
  [ class ("column " ++ subclass) 
  , onMouseOver (RowIndexMouseOver index)
  , onMouseOut (RowIndexMouseOut index)
  ]
  [ child ]

rowOptions : Int -> Html Msg
rowOptions index =
  div
  [ class "column-options" ]
  [ input 
    [ class "column-button close"
    , type' "submit"
    , value "x"
    , onClick (RemoveRow index)
    ]
    []
  , input 
    [ class "column-button"
    , type' "submit"
    , value "v"
    , onClick (NewRow index)
    ]
    []
  ]


--        ROW FORMATTING


formatRowIndex : Radix -> Cells -> (Int, String)
formatRowIndex r row =
  let n = getRowIndex row in
  radixToString (n % r)
  |>(++) (toString (n // r))
  |>trimZeros
  |>(,) n

getRowIndex : Cells -> Index
getRowIndex =
  head >> dummyCell >> .ri

radixToString : Index -> String
radixToString ri =
  get ri numberToHexString
  |>withDefault "z"


--          COLUMN


column : String -> List (Html Msg) -> Html Msg
column subclass = 
  div [ class <| "column " ++ subclass ]

columnClean : List (Html Msg) -> Html Msg
columnClean = div [ class "column clean" ]

columnNumbers : List Bool -> Html Msg
columnNumbers columns =
  let indices = [ 0 .. 8 ] in
  map2 (,) columns [ 0 .. 8 ]
  |>map columnIndexView
  |>(::) (column "index" [])
  |>div [ class "row" ]


columnView : String -> Radix -> Cell -> Html Msg
columnView trackerName radix {ri, ci, content} =
  let
    subclass = 
      if content == "" then 
        if ri % radix /= 0 then ""
        else
          " zero-row"
      else " highlight"

    dataIndex =
      let
        ri_ = toString ri
        ci_ = toString ci
      in
        concat 
        [ trackerName
        , "-"
        , ri_
        , "-"
        , ci_
        ]
  in
  column subclass
  [ input 
    [ class ("cell " ++ subclass)
    , value content 
    , onInput (UpdateCell ri ci)
    , reportKeyDown dataIndex
    , reportKeyUp
    , attribute "data-index" dataIndex
    ] 
    [] 
  ]

reportKeyUp : Attribute Msg
reportKeyUp =
  Json.map ReportKeyUp keyCode
  |>on "keyup"

reportKeyDown : String -> Attribute Msg
reportKeyDown dataIndex =
  Json.map (ReportKeyDown dataIndex) keyCode
  |>on "keydown"

columnIndexView : (Bool, Int) -> Html Msg
columnIndexView (show, index) =
  let
    child = 
      if show then
        div
        [ class "drop-down narrow" ]
        [ columnOptions index ]
      else
        p 
        [ class "index-cell" ]
        [ text (toString index) ] 

    subclass =
      if show then "clean"
      else "index"

  in
  div
  [ class ("column " ++ subclass) 
  , onMouseOver (ColumnIndexMouseOver index)
  , onMouseOut (ColumnIndexMouseOut index)
  ]
  [ child ]

columnOptions : Int -> Html Msg
columnOptions index =
  div
  [ class "column-options" ]
  [ input 
    [ class "column-button close"
    , type' "submit"
    , value "<"
    , onClick (NewColumn index) 
    ]
    []
  , input 
    [ class "column-button"
    , type' "submit"
    , value "x"
    , onClick (RemoveColumn index)
    ]
    []
  ]



