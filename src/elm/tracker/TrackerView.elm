module TrackerView exposing (..)

import Html              exposing (..)
import Html.Attributes   exposing (..)
import Html.Events       exposing (..)
import Html.App          as App
import Aliases           exposing (..)
import List              exposing (map, map2)
import Array             exposing (toList)
import TrackerComponents exposing (..)
import TrackerHeader
import TrackerTypes      exposing (..)


--         VIEW


view : Model -> Html Msg
view model =
  div 
  [ class "tracker-container" ]
  [ header model
  , body model
  ]

header : Model -> Html Msg
header model =
  let {columnHoverOvers} = model in
  div 
  [ class "tracker-header" ] 
  [ TrackerHeader.view model
  , columnNumbers (toList columnHoverOvers)
  ]

body : Model -> Html Msg
body model =
  let {sheet, radix, rowHoverOvers, name} = model in
  toCells sheet
  |>map2 (,) (toList rowHoverOvers)
  |>map (rowView name radix)
  |>div [ class "tracker" ]


--        DATA FORMATTING


toCells : Sheet -> List Cells
toCells {data, width, height} =
  map2 (rowToCells width) data [ 0 .. height ]

rowToCells : Int -> Row -> Int -> Cells
rowToCells width r i =
  map2 (columnToCell i) r [ 0 .. (width - 1) ]

columnToCell : Index -> String -> Index -> Cell
columnToCell ri content ci =
  Cell ri ci content


