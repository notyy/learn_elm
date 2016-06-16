module SearchBackend exposing (..)

import Http
import Json.Decode as Json
import Task

type FetchResult
  = FetchSucceed String
    | FetchFail Http.Error

getRandomGif : String -> Cmd FetchResult
getRandomGif topic =
  let
    url =
      "//api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string
