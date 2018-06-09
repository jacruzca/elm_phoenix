module Signup exposing (..)

import Html exposing (Html, div, h1, form, text, input, button)
import Html.Attributes exposing (id, type_)


type alias User =
    { name : String
    , email : String
    , password : String
    , loggedIn : Bool
    }


initialModel : User
initialModel =
    { name = ""
    , email = ""
    , password = ""
    , loggedIn = False
    }


view : User -> Html msg
view user =
    div []
        [ h1 [] [ text "Sign up" ]
        , Html.form []
            [ div []
                [ text "Name"
                , input
                    [ id "name"
                    , type_ "text"
                    ]
                    []
                ]
            , div []
                [ text "Email"
                , input
                    [ id "email"
                    , type_ "email"
                    ]
                    []
                ]
            , div []
                [ text "Password"
                , input
                    [ id "password"
                    , type_ "password"
                    ]
                    []
                ]
            , div []
                [ button
                    [ type_ "submit" ]
                    [ text "Create account" ]
                ]
            ]
        ]


update : msg -> User -> User
update msg model =
    initialModel


main : Program Never User msg
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }
