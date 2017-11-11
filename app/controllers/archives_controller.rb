class ArchivesController < ApplicationController

  def index
    @archived_projects = Project.archived
  end

  def create
    project = Project.find(params[:project_id])
    project.archived!
    redirect_to archives_url, notice: "Projet #{project.name} archivé."
  end

  def destroy
    project = Project.find(params[:project_id])
    project.active!
    redirect_to projects_url, notice: "Projet #{project.name} désarchivé."
  end
end
