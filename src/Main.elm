module Main exposing (..)

import Html
import Html.App as App
import RandomPet
import Testable


main : Program Never
main =
    App.program
        { init = Testable.init RandomPet.init
        , update = Testable.update RandomPet.update
        , view = RandomPet.view
        , subscriptions = (\model -> Sub.none)
        }
