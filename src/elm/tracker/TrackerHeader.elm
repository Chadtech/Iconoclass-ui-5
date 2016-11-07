module TrackerHeader exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Aliases          exposing (..)
import TrackerTypes     exposing (..)
import List             exposing (map)
import TrackerComponents exposing (..)


--         TRACKER HEADER


view : Model -> Html Msg
view tracker =
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


--        DROP DOWN


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

