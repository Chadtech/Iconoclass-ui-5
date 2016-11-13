module Tracker exposing (..)

import Html              exposing (..)
import Html.Attributes   exposing (..)
import Html.Events       exposing (..)
import Html.App          as App
import Aliases           exposing (..)
import List              exposing (map, member, length)
import String            exposing (append, slice)
import TrackerComponents exposing (..)
import TrackerTypes      exposing (..)
import Array             exposing (fromList, toList, Array, set, get)
import Maybe             exposing (withDefault, Maybe)
import Types
import Dummies           exposing (dummyRow)
import ParseInt          exposing (..)
import TrackerView       exposing (view)


update : Msg -> Model -> (Model, Types.Msg)
update message model =
  case message of
    UpdateCell ri ci str ->
      let {sheet} = model in
      { sheet
      | data =
          let {data, width} = sheet in
          toArrayDeep data
          |>setElement width ri ci str
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

    CloseSheet ->
      let {otherSheets, sheet} = model in
      if length otherSheets == 1 then
        packModel model
      else
        (model, Types.RemoveSheet sheet.name)

    Save ->
      (model, Types.SaveSheet model.sheet)

    Open ->
      (model, Types.OpenDialog model.name)

    ColumnIndexMouseOver index ->
      packModel
      { model 
      | columns = 
          set index True model.columns
      }
      
    ColumnIndexMouseOut index ->
      packModel
      { model 
      | columns = 
          set index False model.columns
      }

    RowIndexMouseOver index ->
      packModel
      { model
      | rows = 
          set index True model.rows
      }

    RowIndexMouseOut index ->
      packModel
      { model
      | rows = 
          set index False model.rows
      }
      
    NoOp ->
      packModel model


packModel : Model -> (Model, Types.Msg)
packModel model = (model, Types.NoOp)

getNewSheetName : List String -> String
getNewSheetName names =
  if member "blank-sheet" names then
    makeNewName "blank-sheet-1" names
  else 
    "blank-sheet"

makeNewName : String -> List String -> String
makeNewName name names =
  if member name names then
    makeNewName (incrementName name) names
  else
    name

handleInt : Result Error Int -> Int
handleInt result =
  case result of
    Ok i -> i 
    Err _ -> 9

incrementName : String -> String
incrementName name =
  slice 12 14 name
  |>parseInt
  |>handleInt
  |>(+) 1
  |>toString
  |>append (slice 0 12 name)


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

