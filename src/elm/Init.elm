module Init exposing (initialModel)

import Types exposing (..)
import List exposing (repeat)
import Dict exposing (Dict, fromList)

initialTracker : Tracker
initialTracker =
  { data =
      repeat 9 ""
      |>repeat 256
  , radix = 16
  }

blankSheet : Sheet
blankSheet =
  repeat 256 (repeat 9 "")

initialModel : Model
initialModel =
  { sheets = 
      fromList
      ("blank-sheet", blankSheet)
  }

