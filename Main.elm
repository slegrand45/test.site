module Main exposing (..)

import Html exposing (Html, p, div, text)
import Html.App as Html
import Html.Lazy
import Material
import Material.Button as Button
import Material.Grid as Grid
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options exposing (css, cs, when)
import Material.Tooltip as Tooltip
import Platform.Cmd exposing (Cmd)


type alias Mdl =
    Material.Model



-- APP


init : ( Model, Cmd Msg )
init =
    ( defaultModel
    , Cmd.batch (Layout.sub0 Mdl :: [])
    )


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = .mdl >> Layout.subs Mdl
        }



-- MODEL


type alias Model =
    { mdl : Mdl
    , clicked : Bool
    }


defaultModel : Model
defaultModel =
    { mdl = Material.model
    , clicked = False
    }



-- ACTION, UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | Clicked
    | Unclicked


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl action' ->
            Material.update action' model

        Clicked ->
            ( { model | clicked = True }, Cmd.none )

        Unclicked ->
            ( { model | clicked = False }, Cmd.none )



-- VIEW


header : Model -> List (Html Msg)
header model =
    [ Layout.row [ cs "mdl-color--indigo-700" ]
        [ Layout.title []
            [ text ("Test") ]
        ]
    ]


viewPage : Model -> Html Msg
viewPage model =
    if model.clicked then
        Grid.grid []
            [ Grid.cell
                [ Grid.size Grid.All 6 ]
                [ p [] [ text "Click on the list icon at right ====>" ] ]
            , Grid.cell
                [ Grid.size Grid.All 6 ]
                [ Button.render Mdl
                    [ 1 ]
                    model.mdl
                    [ Button.icon
                    , Button.onClick Unclicked
                    ]
                    [ Icon.i "list" ]
                ]
            ]
    else
        Grid.grid []
            [ Grid.cell
                [ Grid.size Grid.All 6 ]
                [ Button.render Mdl
                    [ 2 ]
                    model.mdl
                    [ Button.icon
                    , Button.onClick Clicked
                    , Tooltip.attach Mdl [ 3 ]
                    ]
                    [ Icon.i "add" ]
                , Tooltip.render Mdl
                    [ 3 ]
                    model.mdl
                    [ Tooltip.bottom
                    , Tooltip.large
                    ]
                    [ text "TOOLTIP TEST" ]
                ]
            , Grid.cell
                [ Grid.size Grid.All 6 ]
                [ p [] [ text "<==== Click on the add icon at left" ] ]
            ]


view : Model -> Html Msg
view =
    Html.Lazy.lazy view'


view' : Model -> Html Msg
view' model =
    Layout.render Mdl
        model.mdl
        [ Layout.waterfall True ]
        { header = header model
        , drawer = []
        , tabs = ( [], [] )
        , main = [ Options.stylesheet "", viewPage model ]
        }
        |> (\contents ->
                div []
                    [ contents
                    ]
           )
