module Aliases exposing (..)

import Array exposing (Array)

type alias Sheet = List Row

type alias Index = Int
type alias Row   = List String
type alias Radix = Int
type alias Cells = List Cell
type alias Cell  =
  { ri      : Int
  , ci      : Int
  , content : String
  }