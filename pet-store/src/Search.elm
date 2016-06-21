module Search exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import SearchBackend
import Maybe exposing (..)

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

update : (String -> Cmd SearchBackend.FetchResult) -> InputMsg -> Model -> (Model, Cmd InputMsg, Maybe OutputMsg)
update fetchF msg model =
  case msg of
    UserInput query ->
      ({ model | query = query }, Cmd.none, Nothing)
    Submit ->
      (model, Cmd.map SearchCmd (fetchF model.query), Nothing)  -- have to use Cmd.map?
    SearchCmd (SearchBackend.FetchSucceed newUrl) ->
      (model, Cmd.none, Just (ImageUrl newUrl))
    SearchCmd (SearchBackend.FetchFail err) ->
      ({ model | errorMsg = Just (toString err) }, Cmd.none, Nothing)

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
