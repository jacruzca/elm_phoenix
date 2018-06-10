module Signin.SigninView exposing (..)

import Model exposing (Model)
import Signin.SigninMessage exposing (Msg)
import Signin.SigninModel exposing (Login, FormField, Error)
import Html exposing (Html, p, h2, h3, text, div, small, label, li, ul)
import Html.Attributes exposing (href, class, style, for)
import Bootstrap.Card as Card
import Bootstrap.Alert as Alert
import Bootstrap.Card.Block as Block
import Bootstrap.Text as Text
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button


form : Login -> Html Msg
form model =
    Form.form []
        [ viewInput model Signin.SigninModel.Email "E-mail" "text" "email"
        , viewInput model Signin.SigninModel.Password "Password" "password" "password"
        , Button.button [ Button.primary, Button.onClick Signin.SigninMessage.SubmitForm ] [ text "Submit" ]
        ]


viewInput : Login -> FormField -> String -> String -> String -> Html Msg
viewInput model formField label inputType inputName =
    let
        content =
            case formField of
                Signin.SigninModel.Email ->
                    model.email

                Signin.SigninModel.Password ->
                    model.password

        input =
            if inputType == "text" || (formField == Signin.SigninModel.Password && model.showPassword) then
                Input.text
            else
                Input.password
    in
        Form.group []
            [ Form.label [ for inputName ] [ text label ]
            , input [ Input.id inputName, Input.onInput <| Signin.SigninMessage.SetField formField ]
            , viewFormErrors model formField model.errors
            ]


viewFormErrors : Login -> FormField -> List Error -> Html msg
viewFormErrors model field errors =
    if model.showErrors then
        errors
            |> List.filter (\( fieldError, _ ) -> fieldError == field)
            |> List.map (\( _, error ) -> div [] [ Alert.simpleDanger [] [ text error ] ])
            |> div [ class "formErrors" ]
    else
        div [ class "formErrors" ] []


view : Model -> Html Msg
view model =
    let
        _ =
            Debug.log "foo" model
    in
        div
            []
            [ Card.config [ Card.align Text.alignXsCenter ]
                |> Card.header [] [ h3 [] [ text "Sign in" ] ]
                |> Card.block [] [ Block.custom <| form model.signin ]
                |> Card.footer []
                    [ small [ class "text-muted" ] [ text "No account?" ] ]
                |> Card.view
            ]
