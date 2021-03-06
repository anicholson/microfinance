module Views exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, type')
import Html.Events exposing (onClick, onInput)
import Model exposing (..)
import Hop exposing (makeUrl, makeUrlFromLocation, matchUrl, setQuery)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)

{-|-}

view : Model -> Html Msg
view model =
  case model.apiToken of
    Nothing -> div [] []
    otherwise ->
      div [] [ pageView model ]

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
dataEntry = article [ class "message" ] [
             div [ class "message-header" ] [ text "Add a new loan"]
            , div [ class "message-body" ] [
                     p [] [text "Go to the page for the Kiva loan you just made, and copy the URL. Paste that URL into the form below:"]
                    ,p [class "control" ] [
                          input [ class "input", type' "text",  onInput LoanUrl] []]]]

loanPanel : Model -> Html Msg
loanPanel model =
    case model.loanInfo of
      Just loan ->
        article [ class "message" ] [
                   div [ class "message-header" ] [ text "Loan Info" ]
                  , div [ class "message-body" ]  [ loanInfoDisplay loan ]
                  ]
      Nothing ->
        case model.loanUrl of
          Just url ->
            div [ ] [ text "Loan info will show up here." ]
          Nothing ->
            div [ class "is-hidden" ] [ text "" ]

coercedString : Maybe String -> String
coercedString s = Maybe.withDefault "" s

loanInfoDisplay : Loan -> Html Msg
loanInfoDisplay loan =
  let
    activity = coercedString loan.activity
    sector   = coercedString loan.sector
    use      = coercedString loan.use
  in
    div [] [
            p [] [ text loan.name ]
          , p [] [ text loan.description ]
          , p [] [ text activity ]
          , p [] [ text sector ]
          , p [] [ text use ]
          , p [] [ text (toString loan.amount) ]
          ]
