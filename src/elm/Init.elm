module Init exposing (initialModel)

import Types exposing (..)
import Aliases exposing (..)
import TrackerTypes as Tracker
import List exposing (repeat)
import Dict exposing (Dict, fromList)
import Dummies exposing (blankSheet)

initialModel : Model
initialModel =
  { sheets = 
      fromList
      [ (blankSheet.name, blankSheet) ]
  , trackerModels =
      fromList
      [ ("left", Tracker.initialModel "left") 
      , ("middle", Tracker.initialModel "middle")
      , ("right", Tracker.initialModel "right")
      ]
  , directory   = ""
  , metaKeyDown = False
  }



