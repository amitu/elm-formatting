module Basic exposing (all)

import Expect
import Formatting as F exposing ((<>))
import Formatting.Html as F
import Fuzz exposing (int, string)
import Html exposing (Html)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


type alias User =
    { first : String
    , last : String
    , id : Int
    }


userFormat : F.Format User String
userFormat =
    (.first >> F.string)
        <> F.s " "
        <> (.last >> F.string)
        <> F.s " : "
        <> (.id >> F.int)


user : User -> String
user =
    userFormat >> F.print


userH : User -> Html msg
userH =
    (.first >> F.string >> F.text)
        <> F.t " "
        <> (.last >> F.string >> F.text)
        <> F.s " : "
        <> (.id >> F.int >> F.text)
        >> F.html Html.span []


all : Test
all =
    describe "All"
        [ fuzz3 string string int "String" <|
            \f l i ->
                user (User f l i)
                    |> Expect.equal (f ++ " " ++ l ++ " : " ++ toString i)
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
        ]
