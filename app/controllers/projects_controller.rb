class ProjectsController < ApplicationController
  def index
    @projects = show_all_projects? ? Project.active : current_user.projects.active
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.new(project_params)

    if project.save
      Folder.create(name: "#{project.name}", project_id: project.id)
      flash[:notice] = 'Projet créé avec succès.'
      flash[:class] = 'success'
      redirect_to projects_url
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
      project.root_folder.update(name: project.name)
      flash[:class] = 'success'
      flash[:notice] = 'Modifications enregistrées.'
      redirect_to projects_url
    else
      render :edit
    end
  end

  def destroy
    project = current_resource
    project.destroy
    flash[:class] = 'success'
    flash[:notice] = "Projet #{project.name} supprimé."
    redirect_to projects_url
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
