module Types exposing (..)

import List exposing (repeat)
import Dict exposing (Dict)

type Msg 
  = UpdateCell Index Index String


type alias Model =
  { sheets : Dict String Sheet }

type alias Sheet = List Row

type alias Tracker =
  { radix     : Int
  , data      : Sheet
  , sheetName : String
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