module TrackerTypes exposing (..)

import Aliases exposing (..)
import List exposing (repeat)

type alias Model =
  { radix : Int
  , sheet : Sheet
  }

initialModel : Model
initialModel = 
  { radix = 16
  , sheet = blankSheet
  }

blankSheet : Sheet
blankSheet =
  { data = repeat 256 (repeat 9 "")
  , width = 9
  , height = 256
  , name = "blank-sheet"
  }

type Msg 
  = UpdateRadix Int
  | UpdateCell Index Index String