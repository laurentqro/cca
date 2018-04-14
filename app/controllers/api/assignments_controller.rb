class Api::AssignmentsController < Api::ApiController
  def index
    project = Project.find(params[:project_id])
    render json: project.assignments
  end

  def create
    @assignment = Assignment.new(assignment_params)

    if @assignment.save
      render json: @assignment, status: :created
    end
  end

  def destroy
    Assignment.find_by(assignment_params).destroy
    head :ok
  end

  def assignable_users
    @assignable_users = User.unassigned_to_project(params[:project_id])
    render json: @assignable_users, status: :ok
  end

  private

  def assignment_params
    params.require(:assignment).permit(:project_id, :user_id)
  end
end
