module UpdateUtil exposing (..)

import Aliases           exposing (..)
import List              exposing (map, member, length, repeat)
import String
--import TrackerComponents exposing (..)
import TrackerTypes      exposing (..)
import Array             exposing (fromList, toList, Array, set, get)
import Maybe             exposing (withDefault, Maybe)
import Types
import Dummies           exposing (dummyRow)
import ParseInt          exposing (..)
import TrackerView       exposing (view)

insertColumn : Int -> List Row -> List Row
insertColumn index =
  map (insertCell index)

insertCell : Int -> Row -> Row
insertCell index row =
  let
    lefthalf =
      let 
        beforeIndex =
          fromList row
          |>Array.slice 0 index
      in
      fromList [ "" ]
      |>Array.append beforeIndex 

    rightHalf =
      let l = length row in
      fromList row
      |>Array.slice index l
  in
  Array.append lefthalf rightHalf
  |>toList

removeColumn : Int -> List Row -> List Row
removeColumn index =
  map (removeCell index)

removeCell : Int -> Row -> Row
removeCell index row =
  let
    beforeIndex =
      fromList row
      |>Array.slice 0 index

    afterIndex = 
      let l = length row in
      fromList row
      |>Array.slice (index + 1) l
  in
  Array.append beforeIndex afterIndex
  |>toList

newRow : Int -> Int -> List Row -> List Row
newRow width index rows =
  let
    lefthalf =
      let 
        beforeIndex =
          fromList rows
          |>Array.slice 0 index
      in
      fromList [ repeat width "" ]
      |>Array.append beforeIndex 

    rightHalf =
      let l = length rows in
      fromList rows
      |>Array.slice index l
  in
  Array.append lefthalf rightHalf
  |>toList

removeRow : Int -> List Row -> List Row
removeRow index rows =
  let
    beforeIndex =
      fromList rows
      |>Array.slice 0 index

    afterIndex =
      let l = length rows in
      fromList rows
      |>Array.slice (index + 1) l

  in
    Array.append beforeIndex afterIndex
    |>toList

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
  String.slice 12 14 name
  |>parseInt
  |>handleInt
  |>(+) 1
  |>toString
  |>String.append (String.slice 0 12 name)


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
