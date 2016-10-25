module Types exposing (..)

import List exposing (repeat)
import Aliases exposing (..)
import Dict exposing (Dict)
import TrackerTypes as Tracker

type Msg 
  = TrackerMsg String Tracker.Msg
  | UpdateSheet Sheet
  | SyncTrackers
  | NoOp

type alias Model =
  { sheets : Dict String Sheet 
  , trackerModels : Dict String Tracker.Model
  }

