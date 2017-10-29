class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
    @assignments = @project.assignments
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.new(project_params)

    if project.save
      redirect_to project_url(project), notice: 'Projet créé avec succès.'
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
