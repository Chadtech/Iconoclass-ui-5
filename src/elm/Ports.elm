port module Ports exposing (..)

import Types exposing (..)
import Aliases exposing (..)

port focus : (Bool, String, String) -> Cmd msg

port save : SheetPayload -> Cmd msg

port open : String -> Cmd msg

port setDirectory : (String -> msg) -> Sub msg

port openSheets : (List Sheet -> msg) -> Sub msg

