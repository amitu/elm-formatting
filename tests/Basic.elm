module Basic exposing (all)

import Expect
import Formatting as F exposing (c)
import Formatting.Html as H
import Fuzz exposing (int, string)
import Html exposing (Html)
import Test exposing (..)



-- Not yet updated to Elm 0.19
--import Test.Html.Query as Query
--import Test.Html.Selector as Selector


type alias User =
    { first : String
    , last : String
    , id : Int
    }


userFormat : F.Format User String
userFormat =
    (.first >> F.string)
        |> c (F.s " ")
        |> c (.last >> F.string)
        |> c (F.s " : ")
        |> c (.id >> F.int)


user : User -> String
user =
    userFormat >> F.print


userHFormat : F.Format User (Html msg)
userHFormat =
    (.first >> H.string)
        |> c (H.t " ")
        |> c (.last >> H.string)
        |> c (H.t " : ")
        |> c (.id >> H.int)


userH : User -> Html msg
userH =
    H.html Html.span [] userHFormat


{-| This is the example in Formatter.Html
-}
htmlFormat : F.Format User (Html msg)
htmlFormat =
    (.first >> F.string |> H.node Html.h1 [])
        |> c (H.t " ")
        |> c (.last >> H.string)


html : User -> Html msg
html u =
    Html.div [] (htmlFormat u)



--|> c (H.html |> Html.span [])


all : Test
all =
    describe "All"
        [ fuzz3 string string int "String" <|
            \f l i ->
                user (User f l i)
                    |> Expect.equal (f ++ " " ++ l ++ " : " ++ String.fromInt i)
        ]



{- Query and Selector are not yet updated to Elm 0.19.

   , test "HTML First" <|
       \() ->
           userH (User "f" "l" 1)
               |> Query.fromHtml
               |> Query.find [ Selector.tag "span" ]
               |> Query.has [ Selector.text "f" ]
   , test "HTML Count" <|
       \() ->
           userH (User "f" "l" 1)
               |> Query.fromHtml
               |> Query.findAll [ Selector.tag "span" ]
               |> Query.count (Expect.equal 3)

-}
