module Signup.SignupUpdate exposing (..)

import Model exposing (Model)
import Signup.SignupModel exposing (FormField, Error, Signup, FormState)
import Signup.SignupMessage exposing (Msg)
import Signup.SignupCommand exposing (signupCmd, errorDecoder)
import Session.SessionCommand exposing (storeSessionCmd)
import Validate exposing (Validator, ifBlank, ifInvalidEmail)
import Http
import Navigation
import Json.Decode as Decode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        Signup.SignupMessage.NoOp ->
            ( model, Cmd.none )

        Signup.SignupMessage.SubmitForm ->
            case validate model.signup of
                [] ->
                    let
                        signup =
                            model.signup
                    in
                        ( { model | signup = { signup | errors = [], formState = Signup.SignupModel.Fetching } }
                        , signupCmd signup
                        )

                errors ->
                    let
                        signup =
                            model.signup
                    in
                        ( { model | signup = { signup | errors = errors, showErrors = True } }
                        , Cmd.none
                        )

        Signup.SignupMessage.OnSignup (Ok response) ->
            let
                session =
                    model.session

                signup =
                    model.signup

                newSession =
                    Debug.log "newSession" { user = response.user, token = response.token }
            in
                ( { model
                    | session = Maybe.Just newSession
                    , signup = { signup | success = True, showErrors = False }
                  }
                , Cmd.batch [ storeSessionCmd newSession, Navigation.modifyUrl "/#" ]
                )

        Signup.SignupMessage.OnSignup (Err error) ->
            let
                signup =
                    model.signup
            in
                ( { model
                    | signup =
                        { signup
                            | errors =
                                List.filterMap (\err -> err) (showError error)
                            , showErrors = True
                        }
                  }
                , Cmd.none
                )

        Signup.SignupMessage.SetField field value ->
            let
                signup =
                    model.signup
            in
                ( { model
                    | signup = signup |> setField field value |> setErrors
                  }
                , Cmd.none
                )


buildError : List String -> FormField -> Maybe Error
buildError backendError field =
    case List.head backendError of
        Nothing ->
            Nothing

        Just err ->
            Just ( field, err )


showError : Http.Error -> List (Maybe Error)
showError error =
    case error of
        Http.BadStatus response ->
            case Decode.decodeString errorDecoder response.body of
                Ok message ->
                    let
                        m =
                            Debug.log "message" message.errors.email
                    in
                        [ buildError message.errors.email Signup.SignupModel.Email
                        , buildError message.errors.password Signup.SignupModel.Password
                        , buildError message.errors.passwordConfirmation Signup.SignupModel.ConfirmPassword
                        , buildError message.errors.password_confirmation Signup.SignupModel.ConfirmPassword
                        ]

                Err err ->
                    [ buildError [ "Invalid Data" ++ err ] Signup.SignupModel.ConfirmPassword ]

        _ ->
            [ buildError [ httpErrorString error ] Signup.SignupModel.ConfirmPassword ]


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
                    toString message.errors

                Err err ->
                    "Invalid Data" ++ err

        Http.BadPayload message response ->
            "Bad Http Payload: "
                ++ toString message
                ++ " ("
                ++ toString response.status.code
                ++ ")"


setField : FormField -> String -> Signup -> Signup
setField field value model =
    case field of
        Signup.SignupModel.Email ->
            { model | email = value }

        Signup.SignupModel.Password ->
            { model | password = value }

        Signup.SignupModel.Name ->
            { model | name = value }

        Signup.SignupModel.ConfirmPassword ->
            { model | confirmPassword = value }


setErrors : Signup -> Signup
setErrors model =
    case validate model of
        [] ->
            { model | errors = [] }

        errors ->
            { model | errors = errors }


validate : Validator Error Signup
validate =
    Validate.all
        [ .email >> ifInvalidEmail ( Signup.SignupModel.Email, "Please enter a valid e-mail." )
        , .password >> ifBlank ( Signup.SignupModel.Password, "Please enter a password." )
        , .name >> ifBlank ( Signup.SignupModel.Name, "Please enter a name." )
        ]
