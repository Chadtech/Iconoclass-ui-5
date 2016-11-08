module Aliases exposing (..)

import Array exposing (Array)
import List  exposing (repeat)


type alias Sheet = 
  { data   : List Row
  , width  : Int
  , height : Int
  , name   : String
  }

type alias SheetPayload =
  { sheet : Sheet 
  , directory : String
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

newSheet : String -> Sheet
newSheet newSheetName =
  { data   = repeat 256 (repeat 9 "")
  , width  = 9
  , height = 256
  , name   = newSheetName
  }

type alias IndexTriple =
  { sheet : Int 
  , row   : Int
  , col   : Int
  }
