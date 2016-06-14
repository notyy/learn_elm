module PetList exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Http
import Json.Decode as Json
import Search
import Task

-- MODEL

type alias Model = {
  query : String
  , errorMsg : Maybe String
}

init : (Model, Cmd Msg)
init =
  ({ query = "", errorMsg = Nothing } , Cmd.none)

-- UPDATE

type Msg
  = UserInput String
    | Submit
    | FetchSucceed String
    | FetchFail Http.Error
    | ImageUrl String   --this will be processed by other component

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UserInput query ->
      ({ model | query = query }, Cmd.none)
    Submit ->
      (model, getRandomGif model.query)
    FetchSucceed newUrl ->
      (model, Cmd.none)
    FetchFail err ->
      ({ model | errorMsg = Just (toString err) }, Cmd.none)
    ImageUrl url -> (model, Cmd.none)  -- should not come here

getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "//api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string

-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
    div []
    [ input [ placeholder "list pets data", onInput UserInput ] []
    , button [ onClick Submit ] [ text "No_Submit" ]
    , showError model
    ]

showError : Model -> Html Msg
showError model =
  case model.errorMsg of
    Just err ->
      div [style [("color", "red")]] [ text (toString  model.errorMsg) ]
    Nothing ->
      div [style [("color", "green")]] [ text "search ok" ]
