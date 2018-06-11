module Home.HomeUpdate exposing (..)

import Model exposing (Model)
import Home.HomeMessage exposing (Msg)
import Home.HomeApiModel exposing (Member)
import Home.HomeCommand exposing (fetchWeekCmd, getTime, fetch3DaysCmd, fetch24HoursCmd)
import Session.SessionPort exposing (storeSession)
import Navigation
import Date exposing (Date)
import Home.SampleData exposing (timeSeries)


buildTimeSeries : List Member -> List ( Date, Float )
buildTimeSeries members =
    List.map (\member -> ( Date.fromTime member.time, member.close )) members


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Home.HomeMessage.NoOp ->
            ( model, Cmd.none )

        Home.HomeMessage.NavMsg state ->
            let
                h =
                    model.home
            in
                ( { model | home = { h | navState = state } }, Cmd.none )

        Home.HomeMessage.OnFetchWeek (Ok document) ->
            let
                h =
                    model.home

                series =
                    buildTimeSeries document
            in
                ( { model | home = { h | weekData = series } }, Cmd.none )

        Home.HomeMessage.OnFetchWeek (Err _) ->
            let
                h =
                    model.home
            in
                ( { model | home = { h | weekData = [] } }, Cmd.none )

        Home.HomeMessage.OnFetch3Days (Ok document) ->
            let
                h =
                    model.home

                series =
                    buildTimeSeries document
            in
                ( { model | home = { h | weekData = series } }, Cmd.none )

        Home.HomeMessage.OnFetch3Days (Err _) ->
            let
                h =
                    model.home
            in
                ( { model | home = { h | weekData = [] } }, Cmd.none )

        Home.HomeMessage.OnFetch24Hours (Ok document) ->
            let
                h =
                    model.home

                series =
                    buildTimeSeries document
            in
                ( { model | home = { h | weekData = series } }, Cmd.none )

        Home.HomeMessage.OnFetch24Hours (Err _) ->
            let
                h =
                    model.home
            in
                ( { model | home = { h | weekData = [] } }, Cmd.none )

        Home.HomeMessage.Logout ->
            ( model, Cmd.batch [ storeSession Nothing, Navigation.reload ] )

        Home.HomeMessage.ClickButton state ->
            let
                h =
                    model.home
            in
                ( { model | home = { h | buttonState = state } }, getTime )

        Home.HomeMessage.OnTime time ->
            let
                h =
                    model.home

                button =
                    model.home.buttonState

                command =
                    case button of
                        Home.HomeApiModel.LastWeek ->
                            fetchWeekCmd time

                        Home.HomeApiModel.Last3Days ->
                            fetch3DaysCmd time

                        Home.HomeApiModel.Last24Hours ->
                            fetch24HoursCmd time

                        Home.HomeApiModel.None ->
                            Cmd.none
            in
                ( { model | home = { h | time = time } }, command )
