module TrackerTypes exposing (..)

import Aliases exposing (..)
import List exposing (repeat, map)

type alias Model =
  { radix       : Int
  , radixField  : String
  , sheet       : Sheet
  , droppedDown : Bool
  , otherSheets : List String
  , name        : String
  , rows        : List RowModel
  , columns     : List ColumnModel
  }

type alias RowModel =
  { droppedDown : Bool 
  , index       : Int
  }

type alias ColumnModel =
  { droppedRight : Bool
  , index        : Int
  }

initialModel : String -> Model
initialModel name = 
  { radix       = 16
  , radixField  = "16"
  , sheet       = blankSheet
  , droppedDown = False
  , otherSheets = [ "blank-sheet" ]
  , name        = name
  , rows        = map initRow [ 0 .. 8 ]
  , columns     = map initColumn [ 0 .. 255 ]
  }

initRow : Int -> RowModel
initRow index =
  { droppedDown = False
  , index       = index
  }

initColumn : Int -> ColumnModel
initColumn index =
  { droppedRight = False
  , index        = index
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
  | NoOp