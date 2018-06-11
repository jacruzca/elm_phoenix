module Signup.SignupModel exposing (..)


type FormField
    = Name
    | Email
    | Password
    | ConfirmPassword


type FormState
    = Editing
    | Fetching


type alias User =
    { name : String
    , email : String
    }


type alias Signup =
    { errors : List Error
    , name : String
    , email : String
    , password : String
    , confirmPassword : String
    , showErrors : Bool
    , showPassword : Bool
    , formState : FormState
    , success : Bool
    }


type alias BackendError =
    { status : String
    , errors : SingleBackendError
    }


type alias SingleBackendError =
    { password : List String
    , passwordConfirmation : List String
    , password_confirmation : List String
    , email : List String
    }


type alias Error =
    ( FormField, String )


initialModel : Signup
initialModel =
    { errors = []
    , name = ""
    , email = ""
    , password = ""
    , confirmPassword = ""
    , showErrors = False
    , showPassword = False
    , formState = Editing
    , success = False
    }
