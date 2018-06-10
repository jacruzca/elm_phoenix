module Home.HomeModel exposing (..)

import Home.HomeMessage
import Bootstrap.Navbar as Navbar


type alias Model =
    { navState : Navbar.State
    }


initialModel : Model
initialModel =
    let
        ( navState, navCmd ) =
            Navbar.initialState Home.HomeMessage.NavMsg
    in
        { navState = navState }
