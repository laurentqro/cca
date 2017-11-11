class ProjectsController < ApplicationController
  def index
    @projects = Project.active
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
      redirect_to project, notice: 'Projet créé avec succès.'
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    project = Project.find(params[:id])

    if project.update(project_params)
      redirect_to project, notice: 'Modifications enregistrées.'
    else
      render :edit
    end
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
    redirect_to projects_url, notice: "Projet #{project.name} supprimé."
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
