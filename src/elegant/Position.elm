module Elegant.Position
    exposing
        ( Coordinates
        , Position
        , absolute
        , all
        , bottom
        , fixed
        , horizontal
        , left
        , positionToCouples
        , relative
        , right
        , static
        , sticky
        , top
        , vertical
        )

{-| Position contains everything about position rendering.


# Types

@docs Position
@docs Coordinates


# Position selection

@docs static
@docs absolute
@docs relative
@docs fixed
@docs sticky


# Position modifiers

@docs top
@docs right
@docs bottom
@docs left
@docs horizontal
@docs vertical
@docs all


# Compilation

@docs positionToCouples

-}

import Helpers.Shared exposing (..)
import Modifiers exposing (..)
import Surrounded exposing (Surrounded)


{-| Represents a position, whih can be static, absolute, relative, fixed or sticky.
You don't need to bother about it, since it is generated by `static`, `absolute`,
`relative`, `fixed` or `sticky`.
-}
type Position
    = PositionDynamic DynamicPositionning Coordinates
    | PositionStatic


{-| Represents the coordinates of the element. There is top, bottom, left and right.
-}
type alias Coordinates =
    Surrounded SizeUnit


type DynamicPositionning
    = PositionAbsolute
    | PositionRelative
    | PositionFixed
    | PositionSticky


{-| Position the element as static.
-}
static : Position
static =
    PositionStatic


{-| Position the element as absolute, and requires coordinates.
-}
absolute : Modifiers Coordinates -> Position
absolute =
    Surrounded.applyModifiersOnDefault
        >> PositionDynamic PositionAbsolute


{-| Position the element as relative, and requires coordinates.
-}
relative : Modifiers Coordinates -> Position
relative =
    Surrounded.applyModifiersOnDefault
        >> PositionDynamic PositionRelative


{-| Position the element as fixed, and requires coordinates.
-}
fixed : Modifiers Coordinates -> Position
fixed =
    Surrounded.applyModifiersOnDefault
        >> PositionDynamic PositionFixed


{-| Position the element as sticky, and requires coordinates.
-}
sticky : Modifiers Coordinates -> Position
sticky =
    Surrounded.applyModifiersOnDefault
        >> PositionDynamic PositionSticky


defaultSizeUnit : SizeUnit
defaultSizeUnit =
    Px 0


{-| Accepts a size, and modify the top position.
-}
top : SizeUnit -> Modifier Coordinates
top =
    Surrounded.top defaultSizeUnit << modifiersFrom


{-| Accepts a size, and modify the bottom position.
-}
bottom : SizeUnit -> Modifier Coordinates
bottom =
    Surrounded.bottom defaultSizeUnit << modifiersFrom


{-| Accepts a size, and modify the left position.
-}
left : SizeUnit -> Modifier Coordinates
left =
    Surrounded.left defaultSizeUnit << modifiersFrom


{-| Accepts a size, and modify the right position.
-}
right : SizeUnit -> Modifier Coordinates
right =
    Surrounded.right defaultSizeUnit << modifiersFrom


{-| Accepts a size, and modify both the top and bottom positions.
-}
horizontal : SizeUnit -> Modifier Coordinates
horizontal =
    Surrounded.horizontal defaultSizeUnit << modifiersFrom


{-| Accepts a size, and modify both the left and right positions.
-}
vertical : SizeUnit -> Modifier Coordinates
vertical =
    Surrounded.vertical defaultSizeUnit << modifiersFrom


{-| Accepts a size, and modify the four positions.
-}
all : SizeUnit -> Modifier Coordinates
all =
    Surrounded.all defaultSizeUnit << modifiersFrom


{-| Compiles a `Position` to the corresponding CSS list of tuples.
Compiles only styles which are defined, ignoring `Nothing` fields.
-}
positionToCouples : Position -> List ( String, String )
positionToCouples position =
    case position of
        PositionDynamic dynamicPositionningType coordinates ->
            List.concat
                [ [ ( "position", dynamicTypeToString dynamicPositionningType ) ]
                , Surrounded.surroundedToCouples Nothing coordinatesToString coordinates
                ]

        PositionStatic ->
            [ ( "position", "static" ) ]



-- Internals


dynamicTypeToString : DynamicPositionning -> String
dynamicTypeToString dynamic =
    case dynamic of
        PositionAbsolute ->
            "absolute"

        PositionRelative ->
            "relative"

        PositionFixed ->
            "fixed"

        PositionSticky ->
            "sticky"


coordinatesToString : SizeUnit -> List ( String, String )
coordinatesToString padding =
    padding
        |> valueToCouple
        |> List.singleton


valueToCouple : SizeUnit -> ( String, String )
valueToCouple value =
    ( "", sizeUnitToString value )
