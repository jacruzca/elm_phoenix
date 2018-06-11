module Main exposing (..)

import Navigation
import View
import Update
import Model exposing (Model)
import Session.SessionModel
import Session.SessionCommand exposing (checkSessionCmd)


main : Program (Maybe Session.SessionModel.Session) Model Update.Msg
main =
    Navigation.programWithFlags
        Update.ChangeLocation
        { init = init
        , view = View.view
        , update = Update.update
        , subscriptions = (\_ -> Sub.none)
        }


init : Maybe Session.SessionModel.Session -> Navigation.Location -> ( Model, Cmd Update.Msg )
init flags location =
    ( Model.init location flags, Cmd.batch [ checkSessionCmd flags location ] )
