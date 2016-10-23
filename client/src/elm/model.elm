module Model exposing (..)

{-|-}


--Hop.Matchers exposes functions for building route matchers

import Hop.Matchers exposing (..)
import Hop exposing (makeUrl, makeUrlFromLocation, matchUrl, setQuery)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)
import Http exposing (..)
-- ROUTES


{-|
Define your routes as union types
You need to provide a route for when the current URL doesn't match any known route i.e. NotFoundRoute
-}
type Route
  = LoanRoute
  | ThanksRoute
  | NotFoundRoute

type alias Loan =
  { name : String
  , amount : Int
  , description : String
  , activity: Maybe String
  , sector : Maybe String
  , use : Maybe String
  , status : String
  }

type Msg
  = NavigateTo String
  | ApiTokenProvided String
  | SetQuery Query
  | LoanUrl String
  | KivaFail Http.Error
  | LoanInfo Loan

type alias Model =
  { location : Location
  , route : Route
  , loanUrl: Maybe String
  , loanInfo : Maybe Loan
  , apiToken : Maybe String
  }
