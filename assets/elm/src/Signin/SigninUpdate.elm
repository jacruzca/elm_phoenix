module Signin.SigninUpdate exposing (..)

import Model exposing (Model)
import Signin.SigninModel exposing (FormField, Error, Login, FormState)
import Signin.SigninMessage exposing (Msg)
import Signin.SigninCommand exposing (signinCmd, errorDecoder)
import Session.SessionCommand exposing (storeSessionCmd)
import Validate exposing (Validator, ifBlank, ifInvalidEmail)
import Http
import Navigation
import Json.Decode as Decode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        Signin.SigninMessage.NoOp ->
            ( model, Cmd.none )

        Signin.SigninMessage.SubmitForm ->
            case validate model.signin of
                [] ->
                    let
                        login =
                            model.signin
                    in
                        ( { model | signin = { login | errors = [], formState = Signin.SigninModel.Fetching } }
                        , signinCmd login
                        )

                errors ->
                    let
                        login =
                            model.signin
                    in
                        ( { model | signin = { login | errors = errors, showErrors = True } }
                        , Cmd.none
                        )

        Signin.SigninMessage.OnSignin (Ok response) ->
            let
                session =
                    model.session

                login =
                    model.signin

                newSession =
                    Debug.log "newSession" { user = response.user, token = response.token }
            in
                ( { model
                    | session = Maybe.Just newSession
                    , signin = { login | success = True, showErrors = False }
                  }
                , Cmd.batch [ storeSessionCmd newSession, Navigation.modifyUrl "/#" ]
                )

        Signin.SigninMessage.OnSignin (Err error) ->
            let
                login =
                    model.signin
            in
                ( { model
                    | signin =
                        { login
                            | errors =
                                [ ( Signin.SigninModel.Password, httpErrorString error )
                                ]
                            , showErrors = True
                        }
                  }
                , Cmd.none
                )

        Signin.SigninMessage.SetField field value ->
            let
                login =
                    model.signin
            in
                ( { model
                    | signin = login |> setField field value |> setErrors
                  }
                , Cmd.none
                )


httpErrorString : Http.Error -> String
httpErrorString error =
    case error of
        Http.BadUrl text ->
            "Bad Url: " ++ text

        Http.Timeout ->
            "Http Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus response ->
            case Decode.decodeString errorDecoder response.body of
                Ok message ->
                    message.error

                Err err ->
                    "Invalid Data" ++ err

        Http.BadPayload message response ->
            "Bad Http Payload: "
                ++ toString message
                ++ " ("
                ++ toString response.status.code
                ++ ")"


setField : FormField -> String -> Login -> Login
setField field value model =
    case field of
        Signin.SigninModel.Email ->
            { model | email = value }

        Signin.SigninModel.Password ->
            { model | password = value }


setErrors : Login -> Login
setErrors model =
    case validate model of
        [] ->
            { model | errors = [] }

        errors ->
            { model | errors = errors }


validate : Validator Error Login
validate =
    Validate.all
        [ .email >> ifInvalidEmail ( Signin.SigninModel.Email, "Please enter a valid e-mail." )
        , .password >> ifBlank ( Signin.SigninModel.Password, "Please enter a password." )
        ]
