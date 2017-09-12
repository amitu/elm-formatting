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

{-| This library is to write type safe formatter.

A formatter is function that formats a thing into an output. Eg if I have a
record, and I want to convert it to a string, for printing.

The output can be other than string, eg I want to print to "html", say each
show someone's first name as bold, and last name as grayed out.

    import Formatting as F exposing ((<>))

    type alias User =
        { first : String
        , last : String
        }

    userFormat : F.Format User String
    userFormat =
        (.first >> F.string) <> F.s " " <> (.last >> F.string)

    user : User -> String
    user =
        F.print userFormat

This library is heavily influenced by
[krisajenkins/formatting](http://package.elm-lang.org/packages/krisajenkins/formatting/latest/Formatting).

If you want to combine two formatted strings, use `++` or equivalent.

    user : Format User String

    date : Format Date String

    user_date : User -> Date -> String
    user_date u d =
        print user u ++ print date d


# Format Constructors

These help us create type safe formatters. The formatters are of type
`Format a String`, if you want a formatter of other kind, say `Format a b`, you
will can use `map` function to convert. So the path is `a -> String -> b`.

You can ignore these methods and directly write `Format a b` if you so want.

@docs s, string, int, bool, float, number


# Format Composition

@docs (<>), map


# Printer

@docs print


# Helpers

These are some helpers that change the output after the conversion of
`a -> String`, they are simple applications of `map`.

@docs wrap, pad, padLeft, padRight, roundTo


# Definition

@docs Format

-}

import String


{-| Format is a the core type on which this library works on. It is nothing
fancy, for a Format a String, it converts a to list of String.

The reason why we format it into a list of string, is so we can compose more
than one formatter together. Each formatter can return a list of final output
type, `r`, into a list, and our composition function `<>` concatenates the
lists together.

If Elm has support for monoids, we may not have needed the list.

-}
type alias Format a r =
    a -> List r


{-| <> lets you compose formatters together, best demonstrated via an example:

    first : Format User String
    first =
        .first >> string

    last : Format User String
    last =
        .last >> string

    name : Format User String
    name =
        first <> s " " <> last

    print name { first = "Amit", last = "Upadhyay" }

    --> "Amit Upadhyay"

-}
(<>) : Format a r -> Format a r -> Format a r
(<>) lhs rhs =
    \a -> lhs a ++ rhs a


{-| map changes the type of output from one format to another. It can also be
used for general post processing of the output.

    name : Format User String
    name =
        (.name >> string)
            |> map String.toUpper

-}
map : (r1 -> r2) -> Format a r1 -> Format a r2
map f format =
    \a -> List.map f <| format a


{-| Wrap puts a token around the output.

    name : Format User String
    name =
        (.name >> string)
            |> wrap "'"

    print name { name = "Amit" }

    --> 'Amit' (puts "'", before and after).

-}
wrap : r -> Format a r -> Format a r
wrap wrapping format =
    s wrapping <> format <> s wrapping


{-| Pad a string on both sides until it has a given length.
-}
pad : Int -> Char -> Format a String -> Format a String
pad n char =
    map <| String.pad n char


{-| Pad a string on the left until it has a given length.
-}
padLeft : Int -> Char -> Format a String -> Format a String
padLeft n char =
    map <| String.padLeft n char


{-| Pad a string on the right until it has a given length.
-}
padRight : Int -> Char -> Format a String -> Format a String
padRight n char =
    map <| String.padRight n char


{-| Rounds a float to given number of decimal points.
-}
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


{-| Creates a formatter that returns the same string for any value.
-}
s : r -> Format a r
s r =
    \a -> List.singleton r


{-| Creates a formatter for String.
-}
string : Format String String
string =
    List.singleton


any : Format a String
any =
    toString >> List.singleton


{-| Creates a formatter for Int.
-}
int : Format Int String
int =
    any


{-| Creates a formatter for Bool.
-}
bool : Format Bool String
bool =
    any


{-| Creates a formatter for Float.
-}
float : Format Float String
float =
    any


{-| Creates a formatter for Int or Float.
-}
number : Format number String
number =
    any


{-| Print applies a formatter on a value, to produce the output.
-}
print : Format a String -> a -> String
print fn a =
    fn a |> String.join ""
