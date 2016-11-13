module Dummies exposing (..)

import Aliases exposing (..)
import TrackerTypes exposing (Model, RowModel, ColumnModel, initRow, initColumn)
import List exposing (repeat, map)
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
  { radix       = 16
  , radixField  = "16"
  , sheet       = errorSheet
  , droppedDown = False
  , otherSheets = [ "blank-sheet" ]
  , name        = "DUMMIE"
  , rows        = map initRow [ 0 .. 3 ]
  , columns     = map initColumn [ 0 .. 63 ]
  }

dummyRow : Int -> Array String
dummyRow i =
  Array.repeat i "ERROR"

dummyCell : Maybe Cell -> Cell
dummyCell =
  withDefault
  { ri = 99, ci = 99, content = "DUMMY CELL" }