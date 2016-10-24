module Types exposing (..)

import List exposing (repeat)
import Aliases exposing (..)
import Dict exposing (Dict)
import Tracker

type Msg 
  = TrackerMsg String Tracker.Msg


type alias Model =
  { sheets : Dict String Sheet 
  , trackerModels : Dict String Tracker.Model
  }

