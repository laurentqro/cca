class ProjectsController < ApplicationController
  def index
    @projects = show_all_projects? ? Project.active : current_user.projects.active
  end

  def show
    @project = current_resource
    @folder = Folder.new
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
    @project = current_resource
  end

  def update
    project = current_resource

    if project.update(project_params)
      redirect_to project, notice: 'Modifications enregistrées.'
    else
      render :edit
    end
  end

  def destroy
    project = current_resource
    project.destroy
    redirect_to projects_url, notice: "Projet #{project.name} supprimé."
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def current_resource
    @current_resource ||= Project.find(params[:id]) if params[:id]
  end

  def show_all_projects?
    current_user.admin? || current_user.employee?
  end
end
