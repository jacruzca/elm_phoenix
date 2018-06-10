module Update exposing (..)

import Navigation exposing (Location)
import Model exposing (Model)
import Router exposing (screenFromLocation)
import Signin.SigninMessage
import Signin.SigninUpdate


type Msg
    = ChangeLocation Location
    | SigninEvent Signin.SigninMessage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLocation location ->
            { model | screen = screenFromLocation location } ! []

        SigninEvent e ->
            wrapScreen SigninEvent <| Signin.SigninUpdate.update e model


{-| Helper that wraps screen messages
-}
wrapScreen : (msg -> Msg) -> ( Model, Cmd msg ) -> ( Model, Cmd Msg )
wrapScreen toMsg ( model, cmd ) =
    ( model, Cmd.map toMsg cmd )
