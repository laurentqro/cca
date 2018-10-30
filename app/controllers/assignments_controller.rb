class AssignmentsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])

    @assignable_users_json =
      ActiveModelSerializers::SerializableResource.new(
        User.unassigned_to_project(@project.id),
        each_serializer: UserSerializer
    ).as_json

    @project_assignments_json =
      ActiveModelSerializers::SerializableResource.new(
        @project.assignments.includes(:user).order('users.last_name ASC'),
        each_serializer: AssignmentSerializer
    ).as_json
  end
end
