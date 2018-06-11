module Home.HomeUpdate exposing (..)

import Model exposing (Model)
import Home.HomeMessage exposing (Msg)
import Home.HomeApiModel exposing (Member)
import Home.HomeCommand exposing (fetchWeekCmd, getTime)
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

                _ =
                    Debug.log "document" document

                series =
                    buildTimeSeries document

                a =
                    Debug.log "series" series

                b =
                    Debug.log "SAMPLE series" timeSeries
            in
                ( { model | home = { h | weekData = series } }, Cmd.none )

        Home.HomeMessage.OnFetchWeek (Err _) ->
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

                _ =
                    Debug.log "time" time
            in
                ( { model | home = { h | time = time } }, fetchWeekCmd time )
