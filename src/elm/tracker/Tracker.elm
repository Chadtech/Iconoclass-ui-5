module Tracker exposing (..)

import Html              exposing (..)
import Html.Attributes   exposing (..)
import Html.Events       exposing (..)
import Html.App          as App
import Aliases           exposing (..)
import List              exposing (map, map2, length, repeat)
import TrackerComponents exposing (..)
import TrackerTypes      exposing (..)
import Array             exposing (fromList, toList, Array, set, get)
import Maybe             exposing (withDefault, Maybe)
import Types
import Dummies           exposing (dummyRow)


update : Msg -> Model -> (Model, Types.Msg)
update message model =
  case message of
    UpdateCell ri ci newContent ->
      let 
        {sheet} = model 

        sheet' =
          let {data, width} = sheet in
          { sheet
          | data =
              data
              |>toArrayDeep
              |>setElement width ri ci newContent
              |>toListDeep
          }
      in
      (model, Types.UpdateSheet sheet')

    UpdateRadix newRadix ->
      ({ model | radix = newRadix }, Types.NoOp)


--      LIST MODIFICATION

setElement : Int -> Index -> Index -> String -> Array (Array String) -> Array (Array String)
setElement width ri ci str sheet =
  let
    setter =
      get ri sheet
      |>withDefault (dummyRow width)
      |>set ci str
      |>set ri 
  in 
    setter sheet

toArrayDeep : List (List String) -> Array (Array String)
toArrayDeep = map fromList >> fromList

toListDeep : Array (Array String) -> List (List String)
toListDeep = Array.map toList >> toList 



--         VIEW

view : Model -> Html Msg
view {sheet, radix} =
  let {name, data, width, height} = sheet in
  toCells data width height
  |>map (rowView name radix)
  |>div [ class "tracker" ]


-- Tracker data formatting

toCells : List Row -> Int -> Int -> List Cells
toCells t w h =
  map2 (rowToCells w) t [ 0 .. h ]

rowToCells : Int -> Row -> Int -> Cells
rowToCells width r i =
  map2 (columnToCell i) r [ 0 .. (width - 1) ]

columnToCell : Index -> String -> Index -> Cell
columnToCell ri content ci =
  Cell ri ci content


