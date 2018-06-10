module Session.SessionModel exposing (Session, initialModel)

import Signin.SigninModel exposing (User)


type alias Session =
    { user : Maybe User
    , token : Maybe String
    }


initialModel : Session
initialModel =
    { user = Nothing
    , token = Nothing
    }
