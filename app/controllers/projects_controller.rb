class ProjectsController < ApplicationController
  def index
    @projects = show_all_projects? ? Project.active.includes(:subscriptions) : current_user.projects.active.includes(:subscriptions)
  end

  def show
    redirect_to project_folder_path(current_resource, current_resource.root_folder)
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.new(project_params)
    folder = Folder.new(
      name: "#{project.name}",
      project: project,
      user: current_user
    )

    ActiveRecord::Base.transaction do
      project.save!
      folder.save!
    end

    redirect_to projects_url, notice: 'Projet créé avec succès.'
  end

  def edit
    @project = current_resource
  end

  def update
    project = current_resource

    if project.update(project_params)
      project.root_folder.update(name: project.name)
      redirect_to projects_url, notice: 'Modifications enregistrées.'
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
