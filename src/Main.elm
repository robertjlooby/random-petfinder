module Main exposing (..)

import Html
import Html.App as App


main : Program Never
main =
    App.program
        { init = ( "hello, world!", Cmd.none )
        , update = (\msg model -> ( model, Cmd.none ))
        , view = (\model -> Html.div [] [ Html.text model ])
        , subscriptions = (\model -> Sub.none)
        }
