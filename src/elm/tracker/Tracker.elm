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
import ParseInt          exposing (..)

import Debug 


update : Msg -> Model -> (Model, Types.Msg)
update message model =
  case message of
    UpdateCell ri ci newContent ->
      let {sheet} = model in
      { sheet
      | data =
          sheet.data
          |>toArrayDeep
          |>setElement sheet.width ri ci newContent
          |>toListDeep
      }
      |>Types.UpdateSheet
      |>(,) model

    UpdateRadix radixField ->
      let
        newRadix =
          if radixField == "" then model.radix
          else
            case (parseInt radixField) of
              Ok result -> result
              Err _ -> 2
      in
      packModel
      { model 
      | radixField = radixField
      , radix      = newRadix
      }

    UpdateSheetName newName ->
      let {sheet} = model in
      { sheet | name = newName }
      |>Types.UpdateSheetName sheet.name
      |>(,) model


packModel : Model -> (Model, Types.Msg)
packModel model = (model, Types.NoOp)


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
view model =
  let {name} = model.sheet in
  toCells model.sheet
  |>map (rowView name model.radix)
  |>(::) (columnNumbers model.sheet)
  |>(::) (trackerHeader model)
  |>div [ class "tracker" ]


-- Tracker data formatting

toCells : Sheet -> List Cells
toCells {data, width, height} =
  map2 (rowToCells width) data [ 0 .. height ]

rowToCells : Int -> Row -> Int -> Cells
rowToCells width r i =
  map2 (columnToCell i) r [ 0 .. (width - 1) ]

columnToCell : Index -> String -> Index -> Cell
columnToCell ri content ci =
  Cell ri ci content


