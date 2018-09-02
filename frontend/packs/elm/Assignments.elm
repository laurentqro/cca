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
    , url : String
    , projects : List Project
    , company : Company
    , status : String
    , group : String
    }


type alias Company =
    { id : Int
    , name : String
    }

type alias Project =
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

usersListHeader : Html Message
usersListHeader =
  div [ class "flex justify-center text-grey" ] [
      div [ class "w-1/5 h-12" ] [ text "Nom" ]
      , div [ class "w-1/5 h-12" ] [ text "Projets" ]
      , div [ class "w-1/5 h-12" ] [ text "Groupe" ]
      , div [ class "w-1/5 h-12" ] [ text "Niveau d'accès" ]
      , div [ class "w-1/5 h-12" ] [ text "Statut" ]
      , div [ class "w-1/5 h-12" ] [ text "" ]
      ]


assignmentsListItem : Assignment -> Html Message
assignmentsListItem assignment =
    div [ class "flex justify-center" ]
        [ div [ class "w-1/5 h-8" ] [ a [ href assignment.user.url ] [ text assignment.user.full_name ] ]
        , div [ class "w-1/5 h-8" ] [ text (String.join ", " (List.map .name assignment.user.projects)) ]
        , div [ class "w-1/5 h-8" ] [ text (assignment.user.company.name) ]
        , div [ class "w-1/5 h-8" ] [ text assignment.user.group ]
        , div [ class "w-1/5 h-8" ] [ text assignment.user.status ]
        , a [ id ("remove_user_" ++ toString assignment.user.id), class "text-red underline cursor-pointer w-1/5 h-8", onClick (DeleteAssignment assignment) ] [ text "Retirer" ]
              ]

usersListItem : User -> Html Message
usersListItem user =
    div [ class "flex justify-center" ]
        [ div [ class "w-1/5 h-8" ] [ a [ href user.url ] [ text user.full_name ] ]
        , div [ class "w-1/5 h-8" ] [ text (String.join ", " (List.map .name user.projects)) ]
        , div [ class "w-1/5 h-8" ] [ text (user.company.name) ]
        , div [ class "w-1/5 h-8" ] [ text user.group ]
        , div [ class "w-1/5 h-8" ] [ text user.status ]
        , a [ id ("add_user_" ++ toString user.id), class "text-green underline cursor-pointer w-1/5 h-8", onClick (CreateAssignment user) ] [ text "Ajouter" ]
              ]

usersList : Model -> Html Message
usersList model =
    div [ ]
        [ div [ ] [ usersListHeader ]
        , div [ ] (List.map assignmentsListItem model.assignments)
        , div [ ] (List.map usersListItem model.users)
        ]

view : Model -> Html Message
view model =
    div [ class "flex" ] [
        div [ class "w-full" ] [ usersList model ]
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
    Decode.map7 User
        (field "id" Decode.int)
        (field "full_name" Decode.string)
        (field "url" Decode.string)
        (field "projects" (Decode.list decodeProject))
        (field "company" decodeCompany)
        (field "status" Decode.string)
        (field "group" Decode.string)

decodeProject : Decoder Project
decodeProject =
    Decode.map2 Project
        (field "id" Decode.int)
        (field "name" Decode.string)

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
