module Home.HomeMessage exposing (..)

import Bootstrap.Navbar as Navbar


type Msg
    = NoOp
    | NavMsg Navbar.State
    | Logout
