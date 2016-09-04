module Main  exposing (..)

import Http exposing (..)
import Dict
import Navigation
import Hop.Matchers exposing (..)
import Hop exposing (makeUrl, makeUrlFromLocation, matchUrl, setQuery)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)
import Task

import Model exposing (..)
import Views exposing (..)

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
      ( { model | loanUrl = Just url }, fetchLoan url )
    LoanInfo loan ->
      ( { model | loanInfo = Just loan}, Cmd.none )
    KivaFail error ->
      ( model, Cmd.none )

fetchLoan : String -> Cmd Msg
fetchLoan url = Task.perform KivaFail LoanInfo (Task.succeed stubLoan)

stubLoan : Loan
stubLoan = { name = "Stub Loan", amount = 0.00 }

urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
  Navigation.makeParser (.href >> matchUrl routerConfig)


urlUpdate : ( Route, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
  ( { model | route = route, location = location }, Cmd.none )


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