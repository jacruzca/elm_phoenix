module Home.HomeMessage exposing (..)

import Bootstrap.Navbar as Navbar
import Home.HomeApiModel exposing (Member, ButtonState)
import Http
import Time exposing (Time)


type Msg
    = NoOp
    | NavMsg Navbar.State
    | Logout
    | ClickButton ButtonState
    | OnFetchWeek (Result Http.Error (List Member))
    | OnFetch3Days (Result Http.Error (List Member))
    | OnFetch24Hours (Result Http.Error (List Member))
    | OnTime Time
