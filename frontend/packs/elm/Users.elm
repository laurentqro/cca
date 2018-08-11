module Users exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onWithOptions)
import Http
import Json.Decode as Decode exposing (Decoder, field, string, succeed)


-- MODEL


type alias Flags =
    { users : List User
    , usersEndpoint : String
    }


type alias Model =
    { users : List User
    , usersEndpoint : String
    , projectQueryValue : String
    , userQueryValue : String
    , companyQueryValue : String
    }


type alias User =
    { id : Int
    , full_name : String
    , url : String
    , projects : List Project
    , company : Company
    , status : String
    , group : String
    }


type alias Project =
    { id : Int
    , name : String
    }


type alias Company =
    { id : Int
    , name : String
    }


type Msg
    = NoOp
    | SetProjectQueryValue String
    | SetUserQueryValue String
    | SetCompanyQueryValue String
    | UsersFetched (Result Http.Error (List User))
    | ResetFilters



-- INIT


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        { users, usersEndpoint } =
            flags
    in
    ( Model users usersEndpoint "" "" "", Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetUserQueryValue value ->
            { model | userQueryValue = value } ! [ fetchUsers model value ]

        SetProjectQueryValue value ->
            { model | projectQueryValue = value } ! [ fetchUsersAssignedToProject model value ]

        SetCompanyQueryValue value ->
            { model | companyQueryValue = value } ! [ fetchUsersAssignedToCompany model value ]

        UsersFetched (Ok fetchedUsers) ->
            { model | users = fetchedUsers } ! [ Cmd.none ]

        UsersFetched (Err error) ->
            ( model, Cmd.none )

        ResetFilters ->
            { model | projectQueryValue = "", userQueryValue = "", companyQueryValue = "" } ! [ resetFilters model ]

        NoOp ->
            ( model, Cmd.none )



-- COMMANDS


resetFilters : Model -> Cmd Msg
resetFilters model =
    Decode.list decodeUser
        |> Http.get model.usersEndpoint
        |> Http.send UsersFetched


fetchUsers : Model -> String -> Cmd Msg
fetchUsers model query =
    Decode.list decodeUser
        |> Http.get (model.usersEndpoint ++ "?filter=" ++ query ++ "&project=" ++ model.projectQueryValue ++ "&company=" ++ model.companyQueryValue)
        |> Http.send UsersFetched


fetchUsersAssignedToProject : Model -> String -> Cmd Msg
fetchUsersAssignedToProject model query =
    Decode.list decodeUser
        |> Http.get (model.usersEndpoint ++ "?project=" ++ query ++ "&company=" ++ model.companyQueryValue ++ "&filter=" ++ model.userQueryValue)
        |> Http.send UsersFetched


fetchUsersAssignedToCompany : Model -> String -> Cmd Msg
fetchUsersAssignedToCompany model query =
    Decode.list decodeUser
        |> Http.get (model.usersEndpoint ++ "?company=" ++ query ++ "&project=" ++ model.projectQueryValue ++ "&filter=" ++ model.userQueryValue)
        |> Http.send UsersFetched


decodeProject : Decoder Project
decodeProject =
    Decode.map2 Project
        (field "id" Decode.int)
        (field "name" Decode.string)


decodeUser : Decoder User
decodeUser =
    Decode.map7 User
        (field "id" Decode.int)
        (field "full_name" Decode.string)
        (field "url" Decode.string)
        (field "projects" (Decode.list decodeProject))
        (field "company" decodeCompany)
        (field "status" Decode.string)
        (field "group" Decode.string)


decodeCompany : Decoder Company
decodeCompany =
    Decode.map2 Company
        (field "id" Decode.int)
        (field "name" Decode.string)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "flex" ]
        [ div [ class "w-1/4" ] [ userFilters model ]
        , div [ class "w-3/4" ] [ usersList model ]
        ]

userFilters : Model -> Html Msg
userFilters model =
    div [ ]
        [ h3 [ class "mb-4" ] [ text "Filtrer par" ]
        , viewUserFilter model
        , viewProjectFilter model
        , viewCompanyFilter model
        , viewResetFiltersButton
        ]


viewResetFiltersButton : Html Msg
viewResetFiltersButton =
    a
        [ onWithOptions
            "click"
            { preventDefault = True
            , stopPropagation = True
            }
            (Decode.succeed ResetFilters)
        , href "#"
        , class ""
        ]
        [ text "Supprimer les filtres" ]


viewProjectFilter : Model -> Html Msg
viewProjectFilter model =
    div [ class "field" ]
        [ label [ for "project_filter", class "label" ] [ text "Projet" ]
        , div [ class "control" ]
            [ input
                [ class "input"
                , id "project_filter"
                , type_ "text"
                , placeholder "Projet"
                , value model.projectQueryValue
                , onInput SetProjectQueryValue
                ]
                []
            ]
        ]


viewUserFilter : Model -> Html Msg
viewUserFilter model =
    div [ for "user_filter", class "field" ]
        [ label [ for "user_filter", class "label" ] [ text "Utilisateur" ]
        , div [ class "control" ]
            [ input
                [ class "input"
                , id "user_filter"
                , type_ "text"
                , placeholder "Utilisateur"
                , value model.userQueryValue
                , onInput SetUserQueryValue
                , autofocus True
                ]
                []
            ]
        ]


viewCompanyFilter : Model -> Html Msg
viewCompanyFilter model =
    div [ class "field" ]
        [ label [ for "company_filter", class "label" ] [ text "Groupe" ]
        , div [ class "control" ]
            [ input
                [ class "input"
                , id "company_filter"
                , type_ "text"
                , placeholder "Projet"
                , value model.companyQueryValue
                , onInput SetCompanyQueryValue
                ]
                []
            ]
        ]


usersListHeader : Html Msg
usersListHeader =
  div [ class "flex justify-center text-grey" ] [
      div [ class "w-1/5 h-12" ] [ text "Nom" ]
      , div [ class "w-1/5 h-12" ] [ text "Projets" ]
      , div [ class "w-1/5 h-12" ] [ text "Groupe" ]
      , div [ class "w-1/5 h-12" ] [ text "Niveau d'accès" ]
      , div [ class "w-1/5 h-12" ] [ text "Statut" ]
      ]


usersList : Model -> Html Msg
usersList model =
    div [ ]
        [ div [ ] [ usersListHeader ]
        , div [ ] (List.map usersListItem model.users)
        ]


usersListItem : User -> Html Msg
usersListItem user =
    div [ class "flex justify-center" ]
        [ div [ class "w-1/5 h-8" ] [ a [ href user.url ] [ text user.full_name ] ]
        , div [ class "w-1/5 h-8" ] [ text (String.join ", " (List.map .name user.projects)) ]
        , div [ class "w-1/5 h-8" ] [ text (user.company.name) ]
        , div [ class "w-1/5 h-8" ] [ text user.group ]
        , div [ class "w-1/5 h-8" ] [ text user.status ]
        ]



-- MAIN


main : Program Flags Model Msg
main =
    programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
