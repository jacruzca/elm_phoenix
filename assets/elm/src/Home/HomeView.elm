module Home.HomeView exposing (..)

import Model exposing (Model)
import Html.Events exposing (onClick)
import Html exposing (Html, div, text, h1, h2, a)
import Html.Attributes exposing (..)
import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Home.HomeMessage exposing (Msg)


menuItems : Model -> Navbar.CustomItem Msg
menuItems model =
    let
        message =
            Home.HomeMessage.Logout
    in
        Navbar.customItem
            (Grid.container
                []
                [ Grid.row []
                    [ Grid.col []
                        [ a
                            [ href "#" ]
                            [ text "Home" ]
                        ]
                    , Grid.col
                        [ Col.xs12, Col.mdAuto ]
                        [ a
                            [ href "/#", onClick message ]
                            [ text "Logout" ]
                        ]
                    ]
                ]
            )


menu : Model -> Html Msg
menu model =
    Navbar.config Home.HomeMessage.NavMsg
        |> Navbar.collapseMedium
        |> Navbar.brand [ href "#" ] [ text "SPA Example by Jhon" ]
        |> Navbar.customItems [ (menuItems model) ]
        |> Navbar.view model.home.navState


getCurrentUser : Model -> String
getCurrentUser model =
    case model.session of
        Nothing ->
            ""

        Just session ->
            case session.user of
                Nothing ->
                    ""

                Just user ->
                    user.name


mainContent : Model -> List (Html Msg)
mainContent model =
    [ h1 [] [ text ("Welcome " ++ (getCurrentUser model)) ]
    ]


view : Model -> Html Msg
view model =
    div []
        [ menu model
        , Grid.container [] <| mainContent model
        ]
