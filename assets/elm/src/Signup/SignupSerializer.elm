module Signup.SignupSerializer exposing (..)

import Json.Encode as Encode
import Signup.SignupModel exposing (Signup)


signupEncoder : Signup -> Encode.Value
signupEncoder signup =
    let
        attributes =
            [ ( "name", Encode.string signup.name )
            , ( "email", Encode.string signup.email )
            , ( "password", Encode.string signup.password )
            , ( "password_confirmation", Encode.string signup.confirmPassword )
            ]
    in
        Encode.object attributes
