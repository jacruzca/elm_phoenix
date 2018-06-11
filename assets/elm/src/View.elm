module View exposing (view)

import Html exposing (..)
import Update exposing (Msg)
import Router exposing (Screen(..))
import Model exposing (Model)
import Signin.SigninView
import Signup.SignupView
import Home.HomeView


view : Model -> Html Msg
view model =
    case model.screen of
        Main ->
            wrapScreen Update.HomeEvent <| Home.HomeView.view model

        Signin ->
            wrapScreen Update.SigninEvent <| Signin.SigninView.view model

        Signup ->
            wrapScreen Update.SignupEvent <| Signup.SignupView.view model


wrapScreen : (msg -> Msg) -> Html msg -> Html Msg
wrapScreen =
    Html.map
