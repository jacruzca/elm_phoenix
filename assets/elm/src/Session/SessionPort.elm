port module Session.SessionPort exposing (storeSession)


port storeSession : Maybe String -> Cmd msg
