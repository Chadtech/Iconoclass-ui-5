module Util exposing (..)

import Dict exposing (fromList, Dict, get)
import String exposing (uncons)
import Maybe exposing (withDefault, Maybe)


numberToHexString : Dict Int String
numberToHexString =
  fromList
  [ (0, "0")
  , (1, "1")
  , (2, "2")
  , (3, "3")
  , (4, "4")
  , (5, "5")
  , (6, "6")
  , (7, "7")
  , (8, "8")
  , (9, "9")
  , (10, "a")
  , (11, "b")
  , (12, "c")
  , (13, "d")
  , (14, "e")
  , (15, "f")
  , (16, "g")
  , (17, "h")
  , (18, "i")
  , (19, "j")
  , (20, "k")
  , (21, "l")
  , (22, "m")
  , (23, "n")
  ]

trimZeros : String -> String
trimZeros str =
  let
    (head', tail') =
      uncons str
      |>withDefault ('z', "zyx")
  in
  if tail' == "" then str
  else
    if head' /= '0' then str
    else trimZeros tail'