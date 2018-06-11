module Home.HomeModel exposing (..)

import Home.HomeMessage
import Home.HomeApiModel exposing (Member, ButtonState)
import Bootstrap.Navbar as Navbar
import Date exposing (Date)


type alias Model =
    { navState : Navbar.State
    , weekData : List ( Date, Float )
    , buttonState : ButtonState
    , time : Float
    }


initialModel : Model
initialModel =
    let
        ( navState, navCmd ) =
            Navbar.initialState Home.HomeMessage.NavMsg
    in
        { navState = navState, weekData = [], buttonState = Home.HomeApiModel.None, time = 0 }
