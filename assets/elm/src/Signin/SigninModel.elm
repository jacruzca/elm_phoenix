module Signin.SigninModel exposing (..)


type FormField
    = Email
    | Password


type FormState
    = Editing
    | Fetching


type alias User =
    { name : String
    , email : String
    }


type alias Login =
    { errors : List Error
    , email : String
    , password : String
    , showErrors : Bool
    , showPassword : Bool
    , formState : FormState
    , success : Bool
    }


type alias Signedin =
    { user : User
    , token : String
    }


type alias BackendError =
    { status : String
    , error : String
    }


type alias Error =
    ( FormField, String )


initialModel : Login
initialModel =
    { errors = []
    , email = ""
    , password = ""
    , showErrors = False
    , showPassword = False
    , formState = Editing
    , success = False
    }
