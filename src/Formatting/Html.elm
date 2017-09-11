module Formatting.Html exposing (html, node)

import Formatting exposing (Format, map)
import Html exposing (Html)


node :
    (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> List (Html.Attribute msg)
    -> Format a String
    -> Format a (Html msg)
node n attrs =
    map (Html.text >> List.singleton) >> map (n attrs)


html : Format a (Html msg) -> a -> Html msg
html fn a =
    fn a |> Html.span []
