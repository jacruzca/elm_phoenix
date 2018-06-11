module Session.SessionCommand exposing (storeSessionCmd, checkSessionCmd, checkSession)

import Session.SessionModel exposing (Session)
import Session.SessionSerializer exposing (sessionEncoder)
import Session.SessionPort
import Json.Encode as Encode
import Navigation


storeSessionCmd : Session -> Cmd msg
storeSessionCmd session =
    sessionEncoder session
        |> Encode.encode 0
        |> Just
        |> Session.SessionPort.storeSession


checkSession : Maybe Session -> Bool
checkSession session =
    case session of
        Nothing ->
            False

        Just session ->
            case session.user of
                Nothing ->
                    False

                Just user ->
                    case session.token of
                        Nothing ->
                            False

                        Just token ->
                            True


checkSessionCmd : Maybe Session -> Navigation.Location -> Cmd msg
checkSessionCmd session location =
    if checkSession session then
        Navigation.modifyUrl "/#"
    else if location.hash == "signin" then
        Navigation.modifyUrl "/#signin"
    else
        Navigation.modifyUrl "/#signup"
