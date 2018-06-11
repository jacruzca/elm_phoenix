module Signin.SigninCommand exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Signin.SigninMessage exposing (Msg)
import Signin.SigninSerializer exposing (loginEncoder)
import Session.SessionSerializer exposing (sessionDecoder)
import Session.SessionModel exposing (Session)
import Signin.SigninModel exposing (Login, User, BackendError)


signinUrl : String
signinUrl =
    "http://localhost:4000/api/v1/signin"


errorDecoder : Decode.Decoder BackendError
errorDecoder =
    decode BackendError
        |> required "status" Decode.string
        |> required "errors" Decode.string


signinRequest : Login -> Http.Request Session
signinRequest login =
    Http.request
        { body = loginEncoder login |> Http.jsonBody
        , expect = Http.expectJson sessionDecoder
        , headers = []
        , method = "POST"
        , timeout = Nothing
        , url = signinUrl
        , withCredentials = False
        }


signinCmd : Login -> Cmd Msg
signinCmd login =
    signinRequest login
        |> Http.send Signin.SigninMessage.OnSignin
