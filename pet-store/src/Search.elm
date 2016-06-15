module Search exposing (Model, InputMsg,OutputMsg, init, update, view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Http
import Json.Decode as Json
import Task

-- MODEL

type alias Model = {
  query : String
  , errorMsg : Maybe String
}

init : (Model, Cmd InputMsg)
init =
  ({ query = "", errorMsg = Nothing } , Cmd.none)

-- UPDATE

type InputMsg
  = UserInput String
    | Submit
    | FetchSucceed String
    | FetchFail Http.Error

type OutputMsg
  = ImageUrl String
    | NoOutput

update : InputMsg -> Model -> (Model, Cmd InputMsg, OutputMsg)
update msg model =
  case msg of
    UserInput query ->
      ({ model | query = query }, Cmd.none, NoOutput)
    Submit ->
      (model, getRandomGif model.query, NoOutput)
    FetchSucceed newUrl ->
      (model, Cmd.none, ImageUrl newUrl)
    FetchFail err ->
      ({ model | errorMsg = Just (toString err) }, Cmd.none, NoOutput)

getRandomGif : String -> Cmd InputMsg
getRandomGif topic =
  let
    url =
      "//api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string

-- VIEW

view : Model -> Html InputMsg
view model =
    div []
    [ input [ placeholder "Text to search", onInput UserInput ] []
    , button [ onClick Submit ] [ text "Submit" ]
    , showError model
    ]

showError : Model -> Html InputMsg
showError model =
  case model.errorMsg of
    Just err ->
      div [style [("color", "red")]] [ text (toString  model.errorMsg) ]
    Nothing ->
      div [style [("color", "green")]] [ text "search ok" ]
