module View exposing (view)

import Html exposing (..)
import Update exposing (Msg)
import Router exposing (Screen(..))
import Model exposing (Model)
import Signin.SigninView
import Home.HomeView


view : Model -> Html Msg
view model =
    let
        _ =
            Debug.log "main foo" model
    in
        case model.screen of
            Main ->
                wrapScreen Update.HomeEvent <| Home.HomeView.view model

            Signin ->
                wrapScreen Update.SigninEvent <| Signin.SigninView.view model

            Signup ->
                div []
                    [ text "Signup pending!" ]


wrapScreen : (msg -> Msg) -> Html msg -> Html Msg
wrapScreen =
    Html.map
