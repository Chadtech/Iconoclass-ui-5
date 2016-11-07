module Types exposing (..)

import List exposing (repeat)
import Aliases exposing (..)
import Dict exposing (Dict)
import TrackerTypes as Tracker

type Msg 
  = TrackerMsg String Tracker.Msg
  | UpdateSheet Sheet
  | UpdateSheetName String Sheet
  | SyncTrackers
  | NewSheet String
  | RemoveSheet String
  | NoOp

type alias Model =
  { sheets : Dict String Sheet 
  , trackerModels : Dict String Tracker.Model
  }

