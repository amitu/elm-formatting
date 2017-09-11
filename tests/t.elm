module Main exposing (..)

import Date exposing (Date)
import Formatting as F
import Formatting.Html as F
import Html exposing (Html)


fullDateHtml : F.Format Date (Html msg)
fullDateHtml =
    (Date.day >> F.int)
        |> F.padLeft 2 '0'
        |> F.node Html.h1 []


fullTimeHtml : F.Format Date (Html msg)
fullTimeHtml =
    (Date.hour >> F.int)
        |> F.padLeft 2 '0'
        |> F.map Html.text


dateTimeHtml : F.Format Date (Html msg)
dateTimeHtml =
    fullDateHtml <> F.s (Html.text "T") <> fullTimeHtml


rfc3339Html : Date -> Html msg
rfc3339Html =
    F.html dateTimeHtml
