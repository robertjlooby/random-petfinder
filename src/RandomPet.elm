module RandomPet exposing (..)

import Html exposing (Html, div, img)
import Html.Attributes exposing (src)
import Json.Decode as Decode exposing ((:=), Decoder)
import Testable.Cmd as TCmd
import Testable.Http as Http
import Testable.Task as Task


type alias RandomPet =
    { imageUrl : String
    }


type alias Photo =
    { id : String
    , size : String
    , url : String
    }


url : String
url =
    "https://api.petfinder.com/pet.getRandom"


apiKey : String
apiKey =
    "ac1d61d00a7f372f821ab6daa9d338cf"


photoDecoder : Decoder Photo
photoDecoder =
    Decode.object3 Photo
        ("@id" := Decode.string)
        ("@size" := Decode.string)
        ("$t" := Decode.string)


photosDecoder : Decoder (List Photo)
photosDecoder =
    Decode.at [ "petfinder", "pet", "media", "photos", "photo" ]
        (Decode.list photoDecoder)


init : ( RandomPet, TCmd.Cmd Msg )
init =
    let
        fullUrl =
            Http.url url
                [ ( "animal", "dog" )
                , ( "format", "json" )
                , ( "key", apiKey )
                , ( "output", "basic" )
                ]
    in
        ( { imageUrl = "loading.gif" }
        , Task.perform (\_ -> ErrorLoading)
            UpdatePhoto
            (Http.get photosDecoder fullUrl)
        )


type Msg
    = NoOp
    | UpdatePhoto (List Photo)
    | ErrorLoading


update : Msg -> RandomPet -> ( RandomPet, TCmd.Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, TCmd.none )

        UpdatePhoto photos ->
            let
                photo =
                    List.filter (\p -> p.id == "1" && p.size == "x") photos
                        |> List.head
            in
                case photo of
                    Just { url } ->
                        ( { model | imageUrl = url }, TCmd.none )

                    Nothing ->
                        Debug.crash "no image with id 1 and size x"

        ErrorLoading ->
            ( { model | imageUrl = "error.gif" }, TCmd.none )


view : RandomPet -> Html Msg
view model =
    div [] [ img [ src model.imageUrl ] [] ]
