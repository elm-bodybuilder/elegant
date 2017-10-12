module Helpers.Shared exposing (..)

{-| -}

import Function
import Color.Convert
import Color exposing (Color)
import Maybe.Extra

unwrapEmptyList : (a -> List b) -> Maybe a -> List b
unwrapEmptyList =
    Maybe.Extra.unwrap []


type SizeUnit
    = Px Int
    | Pt Int
    | Percent Float
    | Vh Float
    | Em Float
    | Rem Float


type Auto
    = Auto


concatNumberWithString : number -> String -> String
concatNumberWithString number str =
    (number |> toString) ++ str


sizeUnitToString : SizeUnit -> String
sizeUnitToString val =
    case val of
        Px x ->
            concatNumberWithString x "px"

        Pt x ->
            concatNumberWithString x "pt"

        Percent x ->
            concatNumberWithString x "%"

        Vh x ->
            concatNumberWithString x "vh"

        Em x ->
            concatNumberWithString x "em"

        Rem x ->
            concatNumberWithString x "rem"


type alias Modifier a =
    a -> a


type alias Modifiers a =
    List (Modifier a)


modifiedElementOrNothing : a -> Modifiers a -> Maybe a
modifiedElementOrNothing default modifiers =
    if List.isEmpty modifiers then
        Nothing
    else
        default
            |> Function.compose modifiers
            |> Just


keepJustValues : List ( String, Maybe a ) -> List ( String, a )
keepJustValues =
    List.concatMap keepJustValue


keepJustValue : ( String, Maybe a ) -> List ( String, a )
keepJustValue ( property, value ) =
    case value of
        Nothing ->
            []

        Just val ->
            [ ( property, val ) ]



-- TODO move in Function


call : (a -> b) -> a -> b
call fun =
    fun


callOn : a -> (a -> b) -> b
callOn var fun =
    fun var


colorToCouple : Color -> ( String, String )
colorToCouple color =
    ( "color", Color.Convert.colorToCssRgba color )


unwrapToCouple : (a -> Maybe b) -> (b -> ( String, String )) -> a -> List ( String, String )
unwrapToCouple getter function =
    getter
        >> Maybe.map function
        >> Maybe.map List.singleton
        >> Maybe.withDefault []


unwrapToCouples : (a -> Maybe b) -> (b -> List ( String, String )) -> a -> List ( String, String )
unwrapToCouples getter function =
    getter
        >> Maybe.map function
        >> Maybe.withDefault []


getModifyAndSet : (b -> Maybe a) -> (b -> Maybe a -> c) -> a -> List (a -> a) -> b -> c
getModifyAndSet getter setterIn default modifiers record =
    record
        |> getter
        |> Maybe.withDefault default
        |> Function.compose modifiers
        |> Just
        |> setterIn record


modifiersFrom : a -> List (b -> a)
modifiersFrom val =
    [ \value -> val ]


setMaybeValue : (Maybe a -> b) -> a -> b
setMaybeValue setter =
    Just >> setter