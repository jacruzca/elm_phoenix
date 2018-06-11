module Signup.SignupView exposing (..)

import Model exposing (Model)
import Signup.SignupMessage exposing (Msg)
import Signup.SignupModel exposing (Signup, FormField, Error)
import Html exposing (Html, a, p, h2, h3, text, div, small, label, li, ul)
import Html.Attributes exposing (href, class, style, for)
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Card as Card
import Bootstrap.Alert as Alert
import Bootstrap.Card.Block as Block
import Bootstrap.Text as Text
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button


form : Signup -> Html Msg
form model =
    Form.form []
        [ viewInput model Signup.SignupModel.Name "Name" "text" "name"
        , viewInput model Signup.SignupModel.Email "E-mail" "text" "email"
        , viewInput model Signup.SignupModel.Password "Password" "password" "password"
        , viewInput model Signup.SignupModel.ConfirmPassword "Confirm Password" "password" "password_confirmation"
        , Button.button [ Button.primary, Button.onClick Signup.SignupMessage.SubmitForm ] [ text "Submit" ]
        ]


viewInput : Signup -> FormField -> String -> String -> String -> Html Msg
viewInput model formField label inputType inputName =
    let
        content =
            case formField of
                Signup.SignupModel.Email ->
                    model.email

                Signup.SignupModel.Name ->
                    model.name

                Signup.SignupModel.Password ->
                    model.password

                Signup.SignupModel.ConfirmPassword ->
                    model.confirmPassword

        input =
            if inputType == "text" || (formField == Signup.SignupModel.Password && model.showPassword) then
                Input.text
            else
                Input.password
    in
        Form.group []
            [ Form.label [ for inputName ] [ text label ]
            , input [ Input.id inputName, Input.onInput <| Signup.SignupMessage.SetField formField ]
            , viewFormErrors model formField model.errors
            ]


viewFormErrors : Signup -> FormField -> List Error -> Html msg
viewFormErrors model field errors =
    if model.showErrors then
        Debug.log "errors " errors
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
            [ Spacing.m4Lg ]
            [ Card.config [ Card.align Text.alignXsCenter ]
                |> Card.header [] [ h3 [] [ text "Sign up" ] ]
                |> Card.block [] [ Block.custom <| form model.signup ]
                |> Card.footer []
                    [ small [ class "text-muted" ] [ a [ href "#signin" ] [ text "Already have an account?" ] ] ]
                |> Card.view
            ]
