module Home.HomeUpdate exposing (..)

import Model exposing (Model)
import Home.HomeMessage exposing (Msg)
import Session.SessionPort exposing (storeSession)
import Navigation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Home.HomeMessage.NoOp ->
            ( model, Cmd.none )

        Home.HomeMessage.NavMsg state ->
            ( { model | home = { navState = state } }
            , Cmd.none
            )

        Home.HomeMessage.Logout ->
            ( model, Cmd.batch [ storeSession Nothing, Navigation.reload ] )
