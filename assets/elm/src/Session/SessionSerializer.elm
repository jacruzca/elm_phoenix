module Session.SessionSerializer exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode
import Json.Decode.Pipeline exposing (decode, required, optional)
import Session.SessionModel exposing (Session)
import Signin.SigninSerializer exposing (userDecoder, userEncoder)


--See https://www.brianthicks.com/post/2016/12/29/adding-new-fields-to-your-json-decoder/


sessionDecoder : Decode.Decoder Session
sessionDecoder =
    decode Session
        |> optional "user" (Decode.map Just userDecoder) Nothing
        |> optional "token" (Decode.map Just Decode.string) Nothing


sessionEncoder : Session -> Encode.Value
sessionEncoder session =
    let
        attributes =
            [ ( "user", userEncoder session.user )
            , ( "token"
              , case session.token of
                    Nothing ->
                        Encode.null

                    Just token ->
                        Encode.string token
              )
            ]
    in
        Encode.object attributes
