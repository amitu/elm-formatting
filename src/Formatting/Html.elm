module Formatting.Html exposing (html, node)

{-| This module is for writing formatter that generates Html. Say you want
a formatter that shows first name in H1 and last name as text:

    import Formatting as F exposing ((<>))
    import Html exposing (Html)

    type alias User =
        { first : String
        , last : String
        }

    userFormat : F.Format User (Html msg)
    userFormat =
        (.first >> F.string |> F.node Html.h1 [])
            <> F.s " "
            <> (.last >> F.string |> F.map Html.text)

    user : User -> Html msg
    user =
        F.html userFormat

@docs node, html

-}

import Formatting exposing (Format, map)
import Html exposing (Html)


{-| node allows you to wrap a String formatter into an Html node.

    name : Format User (Html msg)
    name =
        -- first we create a `Format User String`
        (.first >> string)
            -- then convert it to `Format User (Html msg)`, using H1 tag
            |> node Html.h1 []

-}
node :
    (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> List (Html.Attribute msg)
    -> Format a String
    -> Format a (Html msg)
node n attrs =
    map (Html.text >> List.singleton) >> map (n attrs)


{-| html is the equivalent of Formatting.print for Html.

    name : Format User (Html msg)
    name =
        (.first >> string)
            -- this gives us a `Format User String`
            |> node Html.h1 []


    -- converts it to `Format User (Html msg)`

    user : User -> Html msg
    user u =
        html name u


    --> user {first = "Amit"} == Html.span [] [ Html.h1 [] [ text "Amit" ] ]

It wraps everything inside a `SPAN` tag.

-}
html : Format a (Html msg) -> a -> Html msg
html fn a =
    fn a |> Html.span []
