module TrackerHeader exposing (..)

import Html              exposing (..)
import Html.Attributes   exposing (..)
import Html.Events       exposing (..)
import Aliases           exposing (..)
import TrackerTypes      exposing (..)
import List              exposing (map)
import TrackerComponents exposing (..)


--         TRACKER HEADER


view : Model -> Html Msg
view tracker =
  div
  [ class "row" ]
  [ column ""
    [ p
      [ class "point ignorable" ]
      [ text "radix"]
    ]
  , column ""
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
  , button "new" NewSheet
  , button "open" Open
  , button "save" Save
  , button "close" CloseSheet
  , dropdown tracker
  ]


--        BUTTON


button : String -> Msg -> Html Msg
button label msg =
  columnClean
  [ input 
    [ class "button" 
    , type' "submit"
    , value label
    , onClick msg
    ]
    []
  ]


--        DROP DOWN


dropdown : Model -> Html Msg
dropdown tracker =
  let 
    body = 
      if tracker.droppedDown then
        down tracker
      else
        up tracker
  in
  div 
  [ class "column wide index" ] 
  [ body ]

up : Model -> Html Msg
up {sheet} =
  p 
  [ class "index-cell" 
  , onClick DropDown
  ]
  [ text sheet.name ]

down : Model -> Html Msg
down {otherSheets} =
  map downOption otherSheets
  |>div [ class "dropped-down" ]


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

