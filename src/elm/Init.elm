module Init exposing (initialModel)

import Types exposing (..)
import Aliases exposing (..)
import Tracker
import List exposing (repeat)
import Dict exposing (Dict, fromList)

blankSheet : Sheet
blankSheet =
  repeat 256 (repeat 9 "")

initialModel : Model
initialModel =
  { sheets = 
      fromList
      [ ("blank-sheet", blankSheet) ]
  , trackerModels =
      fromList
      [ ("left", Tracker.initialModel) 
      , ("middle", Tracker.initialModel)
      , ("right", Tracker.initialModel)
      ]
  }

