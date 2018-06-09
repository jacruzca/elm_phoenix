module Model exposing (..)

import Navigation exposing (Location)
import Router exposing (Screen(..), screenFromLocation)
import Signin.SigninModel


type alias Model =
    { screen : Screen
    , signin : Signin.SigninModel.User
    }


init : Location -> Model
init location =
    { screen = screenFromLocation location
    , signin = Signin.SigninModel.initialModel
    }
