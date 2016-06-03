module Main exposing (..)

import ElmTest exposing (runSuite, Test, suite)


tests : Test
tests =
    suite "All tests"
        []


main : Program Never
main =
    runSuite tests
