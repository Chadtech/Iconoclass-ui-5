port module Ports exposing (..)

import Types exposing (..)
import Aliases exposing (..)

port focus : IndexTriple -> Cmd msg

port save : SheetPayload -> Cmd msg

port setDirectory : (String -> msg) -> Sub msg