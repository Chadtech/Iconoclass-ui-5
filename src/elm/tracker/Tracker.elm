module Tracker exposing (..)

import Html              exposing (..)
import Html.Attributes   exposing (..)
import Html.Events       exposing (..)
import Html.App          as App
import Aliases           exposing (..)
import List              exposing (map, map2, length, repeat, member)
import String            exposing (append, slice)
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

    DropDown ->
      packModel
      { model | droppedDown = True }

    SetSheet sheetName ->
      let {sheet} = model in
      (,)
      { model
      | sheet =
        { sheet | name = sheetName }
      , droppedDown = False
      }
      Types.SyncTrackers

    NewSheet ->
      let 
        {sheet, otherSheets} = model

        newName =
          getNewSheetName otherSheets
      in
      (,)
      { model
      | sheet = { sheet | name = newName }
      }
      (Types.NewSheet newName)


packModel : Model -> (Model, Types.Msg)
packModel model = (model, Types.NoOp)

getNewSheetName : List String -> String
getNewSheetName sheetNames =
  if member "blank-sheet" sheetNames then
    generateNewSheetName "blank-sheet-1" sheetNames
  else 
    "blank-sheet"

generateNewSheetName : String -> List String -> String
generateNewSheetName name sheetNames =
  if member name sheetNames then
    let
      nextName =
        slice 12 14 name
        |>parseInt
        |>handleInt
        |>(+) 1
        |>toString
        |>append (slice 0 12 name)
    in
    generateNewSheetName nextName sheetNames
  else
    name

handleInt : Result Error Int -> Int
handleInt result =
  case result of
    Ok i -> i 
    Err _ -> 9


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
  div 
  [ class "tracker-container" ]
  [ header model
  , body model
  ]

header : Model -> Html Msg
header model =
  div 
  [ class "tracker-header" ] 
  [ trackerHeader model
  , columnNumbers model.sheet
  ]

body : Model -> Html Msg
body model =
  let {sheet, radix} = model in
  toCells sheet
  |>map (rowView sheet.name radix)
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


