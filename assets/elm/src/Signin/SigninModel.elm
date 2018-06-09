module Signin.SigninModel exposing (..)


type FormField
    = Email
    | Password


type FormState
    = Editing
    | Fetching


type alias User =
    { errors : List Error
    , email : String
    , password : String
    , showErrors : Bool
    , showPassword : Bool
    , formState : FormState
    }


type alias Error =
    ( FormField, String )


initialModel : User
initialModel =
    { errors = []
    , email = ""
    , password = ""
    , showErrors = False
    , showPassword = False
    , formState = Editing
    }
