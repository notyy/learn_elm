module PetList exposing (..)

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
  imageUrl : String
}

-- UPDATE

type Msg
  = ImageUrl String

init : Model
init =
  { imageUrl = "" }

update : Msg -> Model -> Model
update msg model =
  case msg of
    ImageUrl url -> { model | imageUrl = url}
    

-- VIEW

view : Model -> Html Msg
view model =
    div []
    [
    img [src model.imageUrl] []
    ]
