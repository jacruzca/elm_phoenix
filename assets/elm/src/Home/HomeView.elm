module Home.HomeView exposing (..)

import Model exposing (Model)
import Html.Events exposing (onClick)
import Html exposing (Html, div, text, h1, h2, h4, a)
import Html.Attributes exposing (href)
import Bootstrap.Utilities.Spacing as Spacing
import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid
import Bootstrap.ButtonGroup as ButtonGroup
import Bootstrap.Button as Button
import Bootstrap.Grid.Col as Col
import Home.HomeMessage exposing (Msg)
import Date exposing (Date)
import Svg exposing (Svg, svg, g, Attribute)
import Svg.Attributes exposing (width, height, transform, strokeWidth, stroke, fill, class, d)
import Visualization.Axis as Axis exposing (defaultOptions)
import Visualization.Scale as Scale exposing (ContinuousScale, ContinuousTimeScale)
import Visualization.Shape as Shape
import Home.HomeApiModel


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
    [ h1 [ Spacing.m5Lg ] [ text ("Welcome " ++ (getCurrentUser model)) ]
    , chartButtons model
    , if List.length model.home.weekData > 0 then
        weekChart model.home.weekData
      else
        div [ Spacing.m5Lg ] [ h4 [] [ text "Click on a button to load data" ] ]
    ]


chartButtons : Model -> Html Msg
chartButtons model =
    ButtonGroup.radioButtonGroup []
        [ ButtonGroup.radioButton
            (model.home.buttonState == Home.HomeApiModel.LastWeek)
            [ Button.primary, Button.onClick <| Home.HomeMessage.ClickButton Home.HomeApiModel.LastWeek ]
            [ text "Last Week" ]
        , ButtonGroup.radioButton
            (model.home.buttonState == Home.HomeApiModel.Last3Days)
            [ Button.primary, Button.onClick <| Home.HomeMessage.ClickButton Home.HomeApiModel.Last3Days ]
            [ text "Last 3 Days" ]
        , ButtonGroup.radioButton
            (model.home.buttonState == Home.HomeApiModel.Last24Hours)
            [ Button.primary, Button.onClick <| Home.HomeMessage.ClickButton Home.HomeApiModel.Last24Hours ]
            [ text "Last 24 Hours" ]
        ]


weekChart : List ( Date, Float ) -> Svg msg
weekChart model =
    svg [ width (toString w ++ "px"), height (toString h ++ "px") ]
        [ g [ transform ("translate(" ++ toString (padding - 1) ++ ", " ++ toString (h - padding) ++ ")") ]
            [ xAxis model ]
        , g [ transform ("translate(" ++ toString (padding - 1) ++ ", " ++ toString padding ++ ")") ]
            [ yAxis model ]
        , g [ transform ("translate(" ++ toString padding ++ ", " ++ toString padding ++ ")"), class "series" ]
            [ Svg.path [ area model, stroke "none", strokeWidth "3px", fill "rgba(255, 0, 0, 0.54)" ] []
            , Svg.path [ line model, stroke "red", strokeWidth "3px", fill "none" ] []
            ]
        ]


lastElem : List a -> Maybe a
lastElem =
    List.foldl (Just >> always) Nothing


getFrom : List ( Date, Float ) -> Float
getFrom data =
    case List.head data of
        Nothing ->
            0

        Just ( date, value ) ->
            Date.toTime date


getTo : List ( Date, Float ) -> Float
getTo data =
    case lastElem data of
        Nothing ->
            0

        Just ( date, value ) ->
            Date.toTime date


getMin : List ( Date, Float ) -> Float
getMin data =
    data
        |> List.map (\( d, v ) -> v)
        |> List.minimum
        |> Maybe.withDefault 0


getMax : List ( Date, Float ) -> Float
getMax data =
    data
        |> List.map (\( d, v ) -> v)
        |> List.maximum
        |> Maybe.withDefault 1000


w : Float
w =
    780


h : Float
h =
    450


padding : Float
padding =
    50


xScale : ( Float, Float ) -> ContinuousTimeScale
xScale ( from, to ) =
    Scale.time ( Date.fromTime from, Date.fromTime to ) ( 0, w - 2 * padding )


yScale : ( Float, Float ) -> ContinuousScale
yScale ( min, max ) =
    Scale.linear ( min - 200, max ) ( h - 2 * padding, 0 )


xAxis : List ( Date, Float ) -> Svg msg
xAxis data =
    let
        from =
            getFrom data

        to =
            getTo data

        scale =
            xScale ( from, to )
    in
        Axis.axis { defaultOptions | orientation = Axis.Bottom, tickCount = List.length data } scale


yAxis : List ( Date, Float ) -> Svg msg
yAxis data =
    let
        min =
            getMin data

        max =
            getMax data

        scale =
            yScale ( min, max )
    in
        Axis.axis { defaultOptions | orientation = Axis.Left, tickCount = 5 } scale


transformToLineData : ( Date, Float ) -> ( Float, Float ) -> ( Float, Float ) -> Maybe ( Float, Float )
transformToLineData ( x, y ) ( from, to ) ( min, max ) =
    let
        xsc =
            xScale ( from, to )

        ysc =
            yScale ( min, max )
    in
        Just ( Scale.convert xsc x, Scale.convert ysc y )


tranfromToAreaData : ( Date, Float ) -> ( Float, Float ) -> ( Float, Float ) -> Maybe ( ( Float, Float ), ( Float, Float ) )
tranfromToAreaData ( x, y ) ( from, to ) ( min, max ) =
    let
        xsc =
            xScale ( from, to )

        ysc =
            yScale ( min, max )
    in
        Just
            ( ( Scale.convert xsc x, Tuple.first (Scale.rangeExtent ysc) )
            , ( Scale.convert xsc x, Scale.convert ysc y )
            )


line : List ( Date, Float ) -> Attribute msg
line model =
    let
        from =
            getFrom model

        to =
            getTo model

        min =
            getMin model

        max =
            getMax model

        f =
            \d -> transformToLineData d ( from, to ) ( min, max )
    in
        List.map f model
            |> Shape.line Shape.monotoneInXCurve
            |> d


area : List ( Date, Float ) -> Attribute msg
area model =
    let
        from =
            getFrom model

        to =
            getTo model

        min =
            getMin model

        max =
            getMax model

        f =
            \d -> tranfromToAreaData d ( from, to ) ( min, max )
    in
        List.map f model
            |> Shape.area Shape.monotoneInXCurve
            |> d


view : Model -> Html Msg
view model =
    div []
        [ menu model
        , Grid.container [] <| mainContent model
        ]
