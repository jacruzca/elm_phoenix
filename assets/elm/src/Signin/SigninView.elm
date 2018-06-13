module Signin.SigninView exposing (..)

import Model exposing (Model)
import Signin.SigninMessage exposing (Msg)
import Signin.SigninModel exposing (Login, FormField, Error)
import Html exposing (Html, a, p, h2, h3, input, text, span, div, small, label, li, ul)
import Html.Attributes exposing (href, class, style, for, value, placeholder, name, type_)
import Html.Events exposing (onInput, onClick)


form : Login -> Html Msg
form model =
    div [ class "form" ]
        [ viewInput model Signin.SigninModel.Email "E-mail" "text" "email"
        , viewInput model Signin.SigninModel.Password "Password" "password" "password"
        , input [ type_ "submit", class "button  arrow", value "Sign in", onClick Signin.SigninMessage.SubmitForm ]
            []
        , div [ class "footer" ]
            [ a [ href "/#signup" ] [ text "No account?" ]
            ]
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
    in
        div []
            [ input [ type_ inputType, placeholder label, name inputName, onInput (Signin.SigninMessage.SetField formField) ]
                []
            , viewFormErrors model formField model.errors
            ]


viewFormErrors : Login -> FormField -> List Error -> Html msg
viewFormErrors model field errors =
    if model.showErrors then
        errors
            |> List.filter (\( fieldError, _ ) -> fieldError == field)
            |> List.map (\( _, error ) -> div [] [ span [ class "error" ] [ text error ] ])
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
            model.signin
        ]
