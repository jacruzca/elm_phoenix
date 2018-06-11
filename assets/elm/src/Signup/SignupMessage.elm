module Signup.SignupMessage exposing (..)

import Signup.SignupModel exposing (FormField)
import Session.SessionModel exposing (Session)
import Http


type Msg
    = NoOp
    | SubmitForm
    | SetField FormField String
    | OnSignup (Result Http.Error Session)
