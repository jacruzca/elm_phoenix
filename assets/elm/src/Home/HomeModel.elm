module Home.HomeModel exposing (..)

import Home.HomeMessage
import Home.HomeApiModel exposing (Member, ButtonState)
import Date exposing (Date)


type alias Model =
    { weekData : List ( Date, Float )
    , buttonState : ButtonState
    , time : Float
    }


initialModel : Model
initialModel =
    { weekData = [], buttonState = Home.HomeApiModel.None, time = 0 }
