module Search exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import SearchBackend

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
    | SearchCmd SearchBackend.FetchResult -- this is redundancy

type OutputMsg
  = ImageUrl String
    | NoOutput

update : (String -> Cmd SearchBackend.FetchResult) -> InputMsg -> Model -> (Model, Cmd InputMsg, OutputMsg)
update fetchF msg model =
  case msg of
    UserInput query ->
      ({ model | query = query }, Cmd.none, NoOutput)
    Submit ->
      (model, Cmd.map SearchCmd (fetchF model.query), NoOutput)  -- have to use Cmd.map?
    SearchCmd (SearchBackend.FetchSucceed newUrl) ->
      (model, Cmd.none, ImageUrl newUrl)
    SearchCmd (SearchBackend.FetchFail err) ->
      ({ model | errorMsg = Just (toString err) }, Cmd.none, NoOutput)

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
