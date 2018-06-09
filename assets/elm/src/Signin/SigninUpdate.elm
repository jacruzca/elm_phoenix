module Signin.SigninUpdate exposing (..)

import Model exposing (Model)
import Signin.SigninModel exposing (FormField, Error, User, FormState)
import Validate exposing (Validator, ifBlank, ifInvalidEmail)


type Msg
    = NoOp
    | SubmitForm
    | SetField FormField String


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case Debug.log "msg" msg of
        NoOp ->
            ( model, Cmd.none )

        SubmitForm ->
            case validate model.signin of
                [] ->
                    let
                        user =
                            Debug.log "sigin" model.signin
                    in
                        ( { model | signin = { user | errors = [], formState = Signin.SigninModel.Fetching } }
                        , Cmd.none
                        )

                errors ->
                    let
                        user =
                            Debug.log "sigin" model.signin
                    in
                        ( { model | signin = { user | errors = errors, showErrors = True } }
                        , Cmd.none
                        )

        SetField field value ->
            let
                user =
                    model.signin
            in
                ( { model
                    | signin =
                        user
                            |> setField field value
                            |> setErrors
                  }
                , Cmd.none
                )


setField : FormField -> String -> User -> User
setField field value model =
    case field of
        Signin.SigninModel.Email ->
            { model | email = value }

        Signin.SigninModel.Password ->
            { model | password = value }


setErrors : User -> User
setErrors model =
    case validate model of
        [] ->
            { model | errors = [] }

        errors ->
            { model | errors = errors }


validate : Validator Error User
validate =
    Validate.all
        [ .email >> ifInvalidEmail ( Signin.SigninModel.Email, "Please enter a valid e-mail." )
        , .password >> ifBlank ( Signin.SigninModel.Password, "Please enter a password." )
        ]
