port module Session.SessionPort exposing (storeSession)

import Session.SessionModel


port storeSession : Maybe String -> Cmd msg
