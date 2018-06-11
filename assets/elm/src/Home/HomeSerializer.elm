module Home.HomeSerializer exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Home.HomeApiModel exposing (Member)


dataDecoder : Decode.Decoder a -> Decode.Decoder a
dataDecoder decode =
    Decode.field "Data" decode


memberDecoder : Decode.Decoder Member
memberDecoder =
    decode Member
        |> required "time" (Decode.float |> Decode.map ((*) 1000.0))
        |> required "close" Decode.float
