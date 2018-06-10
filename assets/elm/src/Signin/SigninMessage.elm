module Signin.SigninMessage exposing (..)

import Signin.SigninModel exposing (FormField)
import Session.SessionModel exposing (Session)
import Http


type Msg
    = NoOp
    | SubmitForm
    | SetField FormField String
    | OnSignin (Result Http.Error Session)
