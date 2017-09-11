module Formatting
    exposing
        ( (<>)
        , Format
        , bool
        , float
        , int
        , map
        , number
        , pad
        , padLeft
        , padRight
        , print
        , roundTo
        , s
        , string
        , wrap
        )

import String


type alias Format a r =
    a -> List r


(<>) : Format a r -> Format a r -> Format a r
(<>) l r =
    \a -> l a ++ r a


map : (r1 -> r2) -> Format a r1 -> Format a r2
map f format =
    \a -> List.map f <| format a


wrap : r -> Format a r -> Format a r
wrap wrapping format =
    s wrapping <> format <> s wrapping


pad : Int -> Char -> Format a String -> Format a String
pad n char =
    map <| String.pad n char


padLeft : Int -> Char -> Format a String -> Format a String
padLeft n char =
    map <| String.padLeft n char


padRight : Int -> Char -> Format a String -> Format a String
padRight n char =
    map <| String.padRight n char


roundTo : Int -> Format Float String
roundTo n =
    \value ->
        if n == 0 then
            [ toString (round value) ]
        else
            let
                exp =
                    10 ^ n

                raised =
                    abs (round (value * toFloat exp))

                sign =
                    if value < 0.0 then
                        "-"
                    else
                        ""
            in
            [ sign ]
                ++ int (raised // exp)
                ++ string "."
                ++ string (String.padLeft n '0' (toString (rem raised exp)))


s : r -> Format a r
s r =
    \a -> List.singleton r


string : Format String String
string =
    List.singleton


any : Format a String
any =
    toString >> List.singleton


int : Format Int String
int =
    any


bool : Format Bool String
bool =
    any


float : Format Float String
float =
    any


number : Format number String
number =
    any


print : Format a String -> a -> String
print fn a =
    fn a |> String.join ""
