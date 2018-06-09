module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Update exposing (Msg)
import Router exposing (Screen(..))
import Model exposing (Model)
import Signin.SigninView


view : Model -> Html Msg
view model =
    case model.screen of
        Main ->
            div
                [ style [ ( "border", "#000 1px solid" ) ]
                ]
                [ text "Main!"
                ]

        Signin ->
            wrapScreen Update.SigninEvent <| Signin.SigninView.view model

        Signup ->
            div []
                [ text "Signup pending!" ]


wrapScreen : (msg -> Msg) -> Html msg -> Html Msg
wrapScreen =
    Html.map
