module TrackerTypes exposing (..)

import Aliases exposing (..)
import List exposing (repeat, map)
import Array exposing (Array, fromList)

type alias Model =
  { radix       : Int
  , radixField  : String
  , sheet       : Sheet
  , droppedDown : Bool
  , otherSheets : List String
  , name        : String
  , rows        : Array Bool
  , columns     : Array Bool
  }

initialModel : String -> Model
initialModel name = 
  { radix       = 16
  , radixField  = "16"
  , sheet       = blankSheet
  , droppedDown = False
  , otherSheets = [ "blank-sheet" ]
  , name        = name
  , rows        = fromList (repeat 256 False) 
  , columns     = fromList (repeat 9 False)
  }

blankSheet : Sheet
blankSheet =
  { data = repeat 256 (repeat 9 "")
  , width = 9
  , height = 256
  , name = "blank-sheet"
  }

type Msg 
  = UpdateRadix String
  | UpdateCell Index Index String
  | UpdateSheetName String
  | DropDown
  | SetSheet String
  | NewSheet
  | CloseSheet
  | Save
  | Open
  | ColumnIndexMouseOver Int
  | ColumnIndexMouseOut Int
  | RowIndexMouseOver Int
  | RowIndexMouseOut Int
  | NoOp