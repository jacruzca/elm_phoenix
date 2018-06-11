module Signup.SignupCommand exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)
import Signup.SignupMessage exposing (Msg)
import Signup.SignupSerializer exposing (signupEncoder)
import Session.SessionSerializer exposing (sessionDecoder)
import Session.SessionModel exposing (Session)
import Signup.SignupModel exposing (Signup, BackendError, SingleBackendError)


signupUrl : String
signupUrl =
    "http://localhost:4000/api/v1/signup"


errorsDecoder : Decode.Decoder SingleBackendError
errorsDecoder =
    decode SingleBackendError
        |> optional "email" (Decode.list Decode.string) []
        |> optional "password" (Decode.list Decode.string) []
        |> optional "password_confirmation" (Decode.list Decode.string) []
        |> optional "passwordConfirmation" (Decode.list Decode.string) []


errorDecoder : Decode.Decoder BackendError
errorDecoder =
    decode BackendError
        |> required "status" Decode.string
        |> required "errors" errorsDecoder


signupRequest : Signup -> Http.Request Session
signupRequest login =
    Http.request
        { body = signupEncoder login |> Http.jsonBody
        , expect = Http.expectJson sessionDecoder
        , headers = []
        , method = "POST"
        , timeout = Nothing
        , url = signupUrl
        , withCredentials = False
        }


signupCmd : Signup -> Cmd Msg
signupCmd signup =
    signupRequest signup
        |> Http.send Signup.SignupMessage.OnSignup
