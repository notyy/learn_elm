module Main exposing (..)

import ElmTest exposing (..)
import Example


tests : Test
tests =
    Example.tests


main : Program Never
main =
    runSuite tests
