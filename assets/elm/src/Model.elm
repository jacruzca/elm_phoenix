module Model exposing (..)

import Navigation exposing (Location)
import Router exposing (Screen(..), screenFromLocation)
import Home.HomeModel
import Signin.SigninModel
import Session.SessionModel


type alias Model =
    { screen : Screen
    , signin : Signin.SigninModel.Login
    , session : Maybe Session.SessionModel.Session
    , home : Home.HomeModel.Model
    }


init : Location -> Maybe Session.SessionModel.Session -> Model
init location flags =
    { screen = screenFromLocation location
    , home = Home.HomeModel.initialModel
    , signin = Signin.SigninModel.initialModel
    , session = flags
    }
