module Main  exposing (..)

import Http exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class, type')
import Html.Events exposing (onClick, onInput)
import Dict
import Navigation
import Hop exposing (makeUrl, makeUrlFromLocation, matchUrl, setQuery)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)


--Hop.Matchers exposes functions for building route matchers

import Hop.Matchers exposing (..)


-- ROUTES


{-|
Define your routes as union types
You need to provide a route for when the current URL doesn't match any known route i.e. NotFoundRoute
-}
type Route
    = LoanRoute
    | ThanksRoute
    | NotFoundRoute


{-|
Define matchers
For example:
match1 AboutRoute "/about"
Will match "/about" and return AboutRoute
match2 UserRoute "/users/" int
Will match "/users/1" and return (UserRoute 1)
`int` is a matcher that matches only integers, for a string use `str` e.g.
match2 UserRoute "/users/" str
Would match "/users/abc"
-}
matchers : List (PathMatcher Route)
matchers =
  [ match1 LoanRoute ""
  , match1 ThanksRoute "/thanks"
  ]


routerConfig : Config Route
routerConfig =
  { hash = True
  , basePath = ""
  , matchers = matchers
  , notFound = NotFoundRoute
  }

type alias Loan =
  { name : String
  , amount: Float
  }

type Msg
  = NavigateTo String
  | SetQuery Query
  | LoanUrl String
  | KivaFail Http.Error
  | LoanInfo Loan

type alias Model =
    { location : Location
    , route : Route
    , loanUrl: Maybe String
    , loanInfo : Maybe Loan
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case (Debug.log "msg" msg) of
    NavigateTo path ->
      let
        command =
          makeUrl routerConfig path
                  |> Navigation.newUrl
      in
        ( model, command )
    SetQuery query ->
      let
        command =
          model.location
            |> setQuery query
            |> makeUrlFromLocation routerConfig
            |> Navigation.newUrl
        in
          ( model, command )
    LoanUrl url ->
      ( { model | loanUrl = Just url }, LoanInfo stubLoan )
    LoanInfo loan ->
      ( { model | loanInfo = Just loan}, Cmd.none )
    KivaFail error ->
      ( model, Cmd.none )

fetchLoan : Cmd a  ->  Cmd Msg
fetchLoan url =
  let thing = \x ->  stubLoan
  in
    Cmd.map thing url

stubLoan : Loan
stubLoan = { name = "Stub Loan", amount = 0.00 }

urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
  Navigation.makeParser (.href >> matchUrl routerConfig)


urlUpdate : ( Route, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
  ( { model | route = route, location = location }, Cmd.none )

view : Model -> Html Msg
view model =
  div []
      [ menu model
      , pageView model
      ]

menu : Model -> Html Msg
menu model =
  div []
      [ div []
          [ button
              [ class "btnLoan"
              , onClick (NavigateTo "")
              ]
              [ text "Loan" ]
          ]
      ]

pageView : Model -> Html Msg
pageView model =
  case model.route of
    LoanRoute ->
      loanPage model
    ThanksRoute ->
      div [  class "title" ] [ text "Thanks!" ]
    NotFoundRoute ->
      div [ class "title" ] [ text "not found" ]


loanPage : Model -> Html Msg
loanPage model =
  div [ class "columns"] [
         div [ class "column is-one-third"] [ dataEntry ]
        , div [ class "column is-two-thirds"] [ loanPanel model ]]


dataEntry : Html Msg
dataEntry = article [ class "messsage" ] [
             div [ class "message-header" ] [ text "Add a new loan"]
            , div [ class "message-body" ] [
                     p [] [text "Go to the page for the Kiva loan you just made, and copy the URL. Paste that URL into the form below:"]
                    ,p [class "control" ] [
                          input [ class "input", type' "text",  onInput LoanUrl] []]]]

loanPanel : Model -> Html Msg
loanPanel model =
  case model.loanUrl of
    Just url ->
      div [ ] [ text "Loan info will show up here." ]
    Nothing ->
      div [ class "is-hidden" ] [ text "" ]

init : ( Route, Hop.Types.Location ) -> ( Model, Cmd Msg )
init ( route, location ) =
  ( { location = location,  route = route, loanUrl =  Nothing, loanInfo =  Nothing }, Cmd.none )

main : Program Never
main =
  Navigation.program urlParser
              { init = init
              , view = view
              , update = update
              , urlUpdate = urlUpdate
              , subscriptions = ( always Sub.none)
              }
