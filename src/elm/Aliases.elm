module Aliases exposing (..)

import Array exposing (Array)

type alias Sheet = 
  { data   : List Row
  , width  : Int
  , height : Int
  , name   : String
  }

type alias Index = Int
type alias Row   = List String
type alias Radix = Int
type alias Cells = List Cell
type alias Cell  =
  { ri      : Int
  , ci      : Int
  , content : String
  }