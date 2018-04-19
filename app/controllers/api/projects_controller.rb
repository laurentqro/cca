class Api::ProjectsController < Api::ApiController
  def index
    projects = Project.where("name ILIKE ?", "%#{params[:query]}%")
    render json: projects
  end
end
