module Formatting.Html exposing (html, node, parent, t, text)

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
    user u =
        div [] (userFormat u)

@docs node wrap

-}

import Formatting exposing (Format, map, s)
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


{-| Helper that wraps exact text into Html.text.
-}
t : String -> Format a (Html msg)
t =
    s >> map Html.text


{-| parent lets you wrap current tree inside an HTML node.

    first : Format User (Html msg)
    first =
        (.first >> string)
            |> node span [class "first"]

    last : Format User (Html msg)
    last =
        (.last >> string)
            |> node span [class "last"]

    full_name : Format User (Html msg)
    full_name =
        (first <> t " " <> last) |> parent div [ class [ "full_name" ] ]

    full_name {first = "Amit", last = "Upadhyay"}

    --> <div class="full_name">
    --     <span class="first">Amit</span> <span class="last">Upadhyay</span>
    --  </div>

-}
parent :
    (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> List (Html.Attribute msg)
    -> Format a (Html msg)
    -> Format a (Html msg)
parent n attrs f =
    \a -> [ n attrs (f a) ]


text : List String -> Format a (Html msg)
text l =
    \_ -> List.map Html.text l


html :
    (List (Html.Attribute msg) -> List (Html msg) -> Html msg)
    -> List (Html.Attribute msg)
    -> Format a (Html msg)
    -> a
    -> Html msg
html n attrs f a =
    n attrs (f a)
