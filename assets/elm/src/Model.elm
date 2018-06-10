module Model exposing (..)

import Navigation exposing (Location)
import Router exposing (Screen(..), screenFromLocation)
import Signin.SigninModel
import Session.SessionModel


type alias Model =
    { screen : Screen
    , signin : Signin.SigninModel.Login
    , session : Maybe Session.SessionModel.Session
    }


init : Location -> Maybe Session.SessionModel.Session -> Model
init location flags =
    { screen = screenFromLocation location
    , signin = Signin.SigninModel.initialModel
    , session = flags
    }
