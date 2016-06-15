import Html exposing (..)
import Html.Events exposing (..)
import Html.App as Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Search
import PetList
import Html.App as App

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model = {
  searchBar : Search.Model
  , petList : PetList.Model
}

init : (Model, Cmd Msg)
init =
  let
    (searchModel, _) = Search.init
    (petListModel, _) = PetList.init
  in
    (Model searchModel petListModel , Cmd.none)

-- UPDATE

type Msg
  = Search Search.InputMsg
    | Show PetList.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (model, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div
    []
    [ App.map Search (Search.view model.searchBar)
    , App.map Show (PetList.view model.petList)
    ]
