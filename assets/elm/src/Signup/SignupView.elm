module Signup.SignupView exposing (..)

import Model exposing (Model)
import Signup.SignupMessage exposing (Msg)
import Signup.SignupModel exposing (Signup, FormField, Error)
import Html exposing (Html, a, p, h2, h3, input, text, span, div, small, label, li, ul)
import Html.Attributes exposing (href, class, style, for, value, placeholder, name, type_)
import Html.Events exposing (onInput, onClick)


form : Signup -> Html Msg
form model =
    div [ class "form" ]
        [ viewInput model Signup.SignupModel.Name "Name" "text" "name"
        , viewInput model Signup.SignupModel.Email "E-mail" "text" "email"
        , viewInput model Signup.SignupModel.Password "Password" "password" "password"
        , viewInput model Signup.SignupModel.ConfirmPassword "Confirm Password" "password" "password_confirmation"
        , input [ type_ "submit", class "button  arrow", value "Sign up", onClick Signup.SignupMessage.SubmitForm ]
            []
        , div [ class "footer" ]
            [ a [ href "/#signin" ] [ text "Already have an account?" ]
            ]
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
    in
        div []
            [ input [ type_ inputType, placeholder label, name inputName, onInput (Signup.SignupMessage.SetField formField) ]
                []
            , viewFormErrors model formField model.errors
            ]


viewFormErrors : Signup -> FormField -> List Error -> Html msg
viewFormErrors model field errors =
    if model.showErrors then
        Debug.log "errors " errors
            |> List.filter (\( fieldError, _ ) -> fieldError == field)
            |> List.map (\( _, error ) -> div [] [ div [ class "error" ] [ text error ] ])
            |> div [ class "form-errors" ]
    else
        div [ class "form-errors" ] []


view : Model -> Html Msg
view model =
    div
        [ class "form-page" ]
        [ div [ class "background" ]
            []
        , div
            [ class "header" ]
            [ div []
                [ text "Elm-Phoenix"
                , span
                    []
                    [ text "Jhon" ]
                ]
            ]
        , form
            model.signup
        ]
