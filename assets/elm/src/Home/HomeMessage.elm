module Home.HomeMessage exposing (..)

import Home.HomeApiModel exposing (Member, ButtonState)
import Http
import Time exposing (Time)


type Msg
    = NoOp
    | Logout
    | ClickButton ButtonState
    | OnFetchWeek (Result Http.Error (List Member))
    | OnFetch3Days (Result Http.Error (List Member))
    | OnFetch24Hours (Result Http.Error (List Member))
    | OnTime Time
