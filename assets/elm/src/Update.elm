module Update exposing (..)

import Navigation exposing (Location)
import Model exposing (Model)
import Router exposing (screenFromLocation, Screen(..))
import Signin.SigninMessage
import Signin.SigninUpdate
import Session.SessionCommand exposing (checkSession)


type Msg
    = ChangeLocation Location
    | SigninEvent Signin.SigninMessage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLocation location ->
            let
                check =
                    checkSession model.session

                _ =
                    Debug.log "LOCATION" (screenFromLocation location)
            in
                { model
                    | screen =
                        if check then
                            screenFromLocation location
                        else
                            Signin
                }
                    ! []

        SigninEvent e ->
            wrapScreen SigninEvent <| Signin.SigninUpdate.update e model


{-| Helper that wraps screen messages
-}
wrapScreen : (msg -> Msg) -> ( Model, Cmd msg ) -> ( Model, Cmd Msg )
wrapScreen toMsg ( model, cmd ) =
    ( model, Cmd.map toMsg cmd )
