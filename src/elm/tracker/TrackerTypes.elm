module TrackerTypes exposing (..)

import Aliases exposing (..)
import List exposing (repeat)

type alias Model =
  { radix       : Int
  , radixField  : String
  , sheet       : Sheet
  , droppedDown : Bool
  , otherSheets : List String
  , name        : String
  }

initialModel : String -> Model
initialModel name = 
  { radix       = 16
  , radixField  = "16"
  , sheet       = blankSheet
  , droppedDown = False
  , otherSheets = [ "blank-sheet" ]
  , name        = name
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