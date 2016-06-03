module Main exposing (..)

import ElmTest exposing (runSuite, Test, suite)
import RandomPetTest


tests : Test
tests =
    suite "All tests"
        [ RandomPetTest.tests ]


main : Program Never
main =
    runSuite tests
