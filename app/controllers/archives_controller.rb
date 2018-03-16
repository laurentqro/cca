class ArchivesController < ApplicationController

  def index
    @archived_projects = Project.archived
  end

  def create
    project = Project.find(params[:project_id])
    project.archived!
    flash[:notice] = "Projet #{project.name} archivé."
    flash[:class] = 'success'
    redirect_to archives_url
  end

  def destroy
    project = Project.find(params[:id])
    project.active!
    flash[:notice] = "Projet #{project.name} désarchivé."
    flash[:class] = 'success'
    redirect_to projects_url
  end
end
