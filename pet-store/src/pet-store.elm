import Html exposing (..)
import Html.Events exposing (..)
import Html.App as Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Search
import PetList
import Html.App as App
import SearchBackend
import Maybe exposing (..)

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
    petListModel = PetList.init
  in
    (Model searchModel petListModel , Cmd.none)

-- UPDATE

type Msg
  = SearchComp Search.InputMsg
    | Show PetList.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SearchComp msg ->
      let
        (searchModel, cmdMsg, outputMsg) = Search.update SearchBackend.getRandomGif msg model.searchBar
      in
        case outputMsg of
          Nothing -> ({ model | searchBar = searchModel }, Cmd.map SearchComp cmdMsg)
          Just (Search.ImageUrl url) ->
            let
              petListModel = PetList.update (PetList.ImageUrl url) model.petList
            in
              ({model | searchBar = searchModel, petList = petListModel }, Cmd.map SearchComp cmdMsg)
    Show _ -> (model, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div
    []
    [ App.map SearchComp (Search.view model.searchBar)
    , App.map Show (PetList.view model.petList)
    ]
