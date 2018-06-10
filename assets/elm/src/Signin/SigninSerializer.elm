module Signin.SigninSerializer exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode
import Json.Decode.Pipeline exposing (decode, required)
import Signin.SigninModel exposing (Login, User)


userDecoder : Decode.Decoder User
userDecoder =
    decode User
        |> required "name" Decode.string
        |> required "email" Decode.string


userEncoder : Maybe User -> Encode.Value
userEncoder user =
    case user of
        Nothing ->
            Encode.null

        Just user ->
            let
                attributes =
                    [ ( "name", Encode.string user.name )
                    , ( "email", Encode.string user.email )
                    ]
            in
                Encode.object attributes


loginEncoder : Login -> Encode.Value
loginEncoder login =
    let
        attributes =
            [ ( "email", Encode.string login.email )
            , ( "password", Encode.string login.password )
            ]
    in
        Encode.object attributes
