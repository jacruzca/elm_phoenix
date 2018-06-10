module Session.SessionCommand exposing (..)

import Session.SessionModel exposing (Session)
import Session.SessionSerializer exposing (sessionEncoder)
import Session.SessionPort
import Json.Encode as Encode


storeSessionCmd : Session -> Cmd msg
storeSessionCmd session =
    sessionEncoder session
        |> Encode.encode 0
        |> Just
        |> Session.SessionPort.storeSession
