module TrackerTypes exposing (..)

import Aliases exposing (..)
import List exposing (repeat)

type alias Model =
  { radix     : Int
  , data      : Sheet
  , sheetName : String
  }

initialModel : Model
initialModel = 
  { data =
      repeat 9 ""
      |>repeat 256
  , radix = 16
  , sheetName = "none"
  }

type Msg 
  = UpdateRadix Int
  | UpdateCell Index Index String