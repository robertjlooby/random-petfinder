module RandomPetTest exposing (..)

import ElmTest exposing (Test, assertEqual, suite, test)
import RandomPet exposing (..)
import Testable.Http as Http
import Testable.TestContext exposing (..)


initComponent =
    { init = init
    , update = RandomPet.update
    }


tests : Test
tests =
    suite "RandomPet"
        [ suite "init"
            [ test "imageUrl is initially the loading gif"
                <| assertEqual (fst init).imageUrl "loading.gif"
            , test "initial command is for a random dog"
                <| assertHttpRequest (Http.getRequest "https://api.petfinder.com/pet.getRandom?animal=dog&format=json&key=ac1d61d00a7f372f821ab6daa9d338cf&output=basic")
                    (startForTest initComponent)
            ]
        , suite "update"
            [ test "on success updates the image url"
                <| assertEqual (Ok "http://photos.petfinder.com/photos/pets/35245326/1/?bust=1464651598&width=500&-x.jpg")
                    (Result.map .imageUrl
                        (currentModel
                            (resolveHttpRequest (Http.getRequest "https://api.petfinder.com/pet.getRandom?animal=dog&format=json&key=ac1d61d00a7f372f821ab6daa9d338cf&output=basic")
                                (Http.ok json)
                                (startForTest initComponent)
                            )
                        )
                    )
            , test "on error updates the image url to error"
                <| assertEqual (Ok "error.gif")
                    (Result.map .imageUrl
                        (currentModel
                            (resolveHttpRequest (Http.getRequest "https://api.petfinder.com/pet.getRandom?animal=dog&format=json&key=ac1d61d00a7f372f821ab6daa9d338cf&output=basic")
                                (Http.serverError)
                                (startForTest initComponent)
                            )
                        )
                    )
            ]
        ]


json =
    """{"petfinder":{"pet":{"contact":{"state":{"$t":"CA"},"email":{},"city":{"$t":"Downey"},"zip":{"$t":"90241"},"address1":{"$t":"9777 Seaaca Street"}},"age":{"$t":"Baby"},"size":{"$t":"M"},"media":{"photos":{"photo":[{"@size":"pnt","$t":"http://photos.petfinder.com/photos/pets/35245326/1/?bust=1464651598&width=60&-pnt.jpg","@id":"1"},{"@size":"fpm","$t":"http://photos.petfinder.com/photos/pets/35245326/1/?bust=1464651598&width=95&-fpm.jpg","@id":"1"},{"@size":"x","$t":"http://photos.petfinder.com/photos/pets/35245326/1/?bust=1464651598&width=500&-x.jpg","@id":"1"},{"@size":"pn","$t":"http://photos.petfinder.com/photos/pets/35245326/1/?bust=1464651598&width=300&-pn.jpg","@id":"1"},{"@size":"t","$t":"http://photos.petfinder.com/photos/pets/35245326/1/?bust=1464651598&width=50&-t.jpg","@id":"1"}]}},"id":{"$t":"35245326"},"shelterPetId":{"$t":"16-24164"},"breeds":{"breed":{"$t":"Pit Bull Terrier"}},"name":{"$t":"16-24164"},"sex":{"$t":"M"},"description":{"$t":"The Description"},"mix":{"$t":"no"},"shelterId":{"$t":"CA990"},"animal":{"$t":"Dog"}}}}"""
