module Assignments exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, decodeString, field, string, succeed)
import Json.Encode as Encode


-- MODEL


type alias Model =
    { assignments_endpoint : String
    , assignable_users_endpoint : String
    , project_id : Int
    , assignments : List Assignment
    , users : List User
    }


type alias Assignment =
    { id : Int
    , project_id : Int
    , user : User
    }


type alias User =
    { id : Int
    , full_name : String
    , companies : List Company
    }


type alias Company =
    { id : Int
    , name : String
    }


type alias Flags =
    { assignments_endpoint : String
    , assignable_users_endpoint : String
    , project_id : Int
    , assignments : List Assignment
    , users : List User
    }



-- INIT


init : Flags -> ( Model, Cmd Message )
init flags =
    let
        { assignments_endpoint, assignable_users_endpoint, project_id, assignments, users } =
            flags
    in
    ( Model assignments_endpoint assignable_users_endpoint project_id assignments users, Cmd.none )



-- VIEW


viewTableAssignmentItem : Assignment -> Html Message
viewTableAssignmentItem assignment =
    tr []
        [ td [] [ text assignment.user.full_name ]
        , td [] [ text (String.join ", " (List.map .name assignment.user.companies)) ]
        , td []
            [ button [ class "button is-small is-danger", onClick (DeleteAssignment assignment) ] [ text "Retirer" ]
            ]
        ]


viewTableUserItem : User -> Html Message
viewTableUserItem user =
    tr []
        [ td [] [ text user.full_name ]
        , td [] [ text (String.join ", " (List.map .name user.companies)) ]
        , td []
            [ button [ class "button is-small is-success", onClick (CreateAssignment user) ] [ text "Ajouter" ]
            ]
        ]


view : Model -> Html Message
view model =
    table [ class "table is-fullwidth is-hoverable" ]
        [ thead [] [ th [] [ text "Nom" ], th [] [ text "Groupes" ], th [] [] ]
        , tbody []
            (List.append
                (List.map viewTableAssignmentItem model.assignments)
                (List.map viewTableUserItem model.users)
            )
        ]



-- MESSAGE


type Message
    = CreateAssignment User
    | AssignmentCreated (Result Http.Error Assignment)
    | DeleteAssignment Assignment
    | AssignmentDeleted (Result Http.Error String)
    | UsersFetched (Result Http.Error (List User))
    | AssignmentsFetched (Result Http.Error (List Assignment))



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        AssignmentsFetched (Ok fetchedAssignments) ->
            { model | assignments = fetchedAssignments } ! [ Cmd.none ]

        AssignmentsFetched (Err error) ->
            ( model, Cmd.none )

        CreateAssignment user ->
            ( model, createAssignment model user.id )

        AssignmentCreated (Ok assignment) ->
            ( model, Cmd.batch [ fetchUsers model, fetchAssignments model ] )

        AssignmentCreated (Err error) ->
            ( model, Cmd.none )

        DeleteAssignment assignment ->
            ( model, deleteAssignment model assignment )

        AssignmentDeleted (Ok string) ->
            ( model, Cmd.batch [ fetchUsers model, fetchAssignments model ] )

        AssignmentDeleted (Err error) ->
            ( model, Cmd.none )

        UsersFetched (Ok fetchedUsers) ->
            { model | users = fetchedUsers } ! [ Cmd.none ]

        UsersFetched (Err error) ->
            ( model, Cmd.none )



-- COMMANDS


fetchAssignments : Model -> Cmd Message
fetchAssignments model =
    Decode.list decodeAssignment
        |> Http.get model.assignments_endpoint
        |> Http.send AssignmentsFetched


fetchUsers : Model -> Cmd Message
fetchUsers model =
    Decode.list decodeUser
        |> Http.get model.assignable_users_endpoint
        |> Http.send UsersFetched


createAssignment : Model -> Int -> Cmd Message
createAssignment model userId =
    let
        url =
            model.assignments_endpoint

        body =
            encodeAssignment userId model.project_id
                |> Http.jsonBody

        request =
            Http.request
                { method = "POST"
                , headers = [ Http.header "Content-Type" "application/json" ]
                , url = url
                , body = body
                , expect = Http.expectJson decodeAssignment
                , timeout = Nothing
                , withCredentials = False
                }
    in
    Http.send AssignmentCreated request


deleteAssignment : Model -> Assignment -> Cmd Message
deleteAssignment model assignment =
    let
        url =
            model.assignments_endpoint ++ "/" ++ toString assignment.user.id

        body =
            encodeAssignment assignment.user.id assignment.project_id
                |> Http.jsonBody

        request =
            Http.request
                { method = "DELETE"
                , headers = [ Http.header "Content-Type" "application/json" ]
                , url = url
                , body = body
                , expect = Http.expectString
                , timeout = Nothing
                , withCredentials = False
                }
    in
    Http.send AssignmentDeleted request


encodeAssignment : Int -> Int -> Encode.Value
encodeAssignment userId projectId =
    Encode.object
        [ ( "user_id", Encode.int userId )
        , ( "project_id", Encode.int projectId )
        ]


decodeAssignment : Decoder Assignment
decodeAssignment =
    Decode.map3 Assignment
        (field "id" Decode.int)
        (field "project_id" Decode.int)
        (field "user" decodeUser)


decodeUser : Decoder User
decodeUser =
    Decode.map3 User
        (field "id" Decode.int)
        (field "full_name" Decode.string)
        (field "companies" (Decode.list decodeCompany))


decodeCompany : Decoder Company
decodeCompany =
    Decode.map2 Company
        (field "id" Decode.int)
        (field "name" Decode.string)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.none



-- MAIN


main : Program Flags Model Message
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
