module Home.HomeCommand exposing (..)

import Http
import Json.Decode as Decode
import Home.HomeMessage exposing (Msg)
import Home.HomeSerializer exposing (dataDecoder, memberDecoder)
import Time exposing (Time)
import Task


fetchWeekUrl : Float -> String
fetchWeekUrl time =
    "https://min-api.cryptocompare.com/data/histoday?fsym=ETH&tsym=USD&limit=7&e=CCCAGG&toTs=" ++ toString time


fetchWeekCmd : Float -> Cmd Msg
fetchWeekCmd time =
    let
        request =
            Http.get
                (fetchWeekUrl time)
                (dataDecoder (Decode.list memberDecoder))
    in
        Http.send Home.HomeMessage.OnFetchWeek request


getTime : Cmd Msg
getTime =
    Time.now
        |> Task.perform Home.HomeMessage.OnTime
