module Dummies exposing (..)

import Aliases exposing (..)
import TrackerTypes exposing (Model)
import List exposing (repeat)
import Array exposing (Array)
import Maybe exposing (withDefault)

blankSheet : Sheet
blankSheet =
  { data = repeat 256 (repeat 9 "")
  , width = 9
  , height = 256
  , name = "blank-sheet"
  }

errorSheet : Sheet
errorSheet =
  { data = repeat 64 (repeat 4 "error")
  , width = 4
  , height = 64
  , name = "blank-sheet"
  }

dummyTracker : Model
dummyTracker =
  { radix = 16
  , sheet = errorSheet
  }

dummyRow : Int -> Array String
dummyRow i =
  Array.repeat i "ERROR"

dummyCell : Maybe Cell -> Cell
dummyCell =
  withDefault
  { ri = 99, ci = 99, content = "DUMMY CELL" }