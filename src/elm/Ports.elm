port module Ports exposing (..)

import Types exposing (..)
import Aliases exposing (..)

port focus : IndexTriple -> Cmd msg

port save : Sheet -> Cmd msg
