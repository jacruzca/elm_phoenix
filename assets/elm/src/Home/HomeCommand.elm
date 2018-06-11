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


fetch3DaysUrl : Float -> String
fetch3DaysUrl time =
    "https://min-api.cryptocompare.com/data/histoday?fsym=ETH&tsym=USD&limit=3&e=CCCAGG&toTs=" ++ toString time


fetch24HoursUrl : Float -> String
fetch24HoursUrl time =
    "https://min-api.cryptocompare.com/data/histohour?fsym=ETH&tsym=USD&limit=24&e=CCCAGG&toTs=" ++ toString time


fetchWeekCmd : Float -> Cmd Msg
fetchWeekCmd time =
    let
        request =
            Http.get
                (fetchWeekUrl time)
                (dataDecoder (Decode.list memberDecoder))
    in
        Http.send Home.HomeMessage.OnFetchWeek request


fetch3DaysCmd : Float -> Cmd Msg
fetch3DaysCmd time =
    let
        request =
            Http.get
                (fetch3DaysUrl time)
                (dataDecoder (Decode.list memberDecoder))
    in
        Http.send Home.HomeMessage.OnFetch3Days request


fetch24HoursCmd : Float -> Cmd Msg
fetch24HoursCmd time =
    let
        request =
            Http.get
                (fetch24HoursUrl time)
                (dataDecoder (Decode.list memberDecoder))
    in
        Http.send Home.HomeMessage.OnFetch24Hours request


getTime : Cmd Msg
getTime =
    Time.now
        |> Task.perform Home.HomeMessage.OnTime
