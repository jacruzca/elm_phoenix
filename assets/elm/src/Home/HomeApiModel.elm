module Home.HomeApiModel exposing (..)


type ButtonState
    = None
    | LastWeek
    | Last3Days
    | Last24Hours


type alias Member =
    { time : Float
    , close : Float
    }
