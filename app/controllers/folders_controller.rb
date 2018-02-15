class FoldersController < ApplicationController

  def show
    @project = Project.find(params[:project_id])
    @folder = Folder.find(params[:id])
    @subfolder = Subfolder.new
    @document = Document.new
  end

  def create
    @project = Project.find(params[:project_id])
    @folder = @project.root_folder.children.create(folder_params)

    if @folder.save
      redirect_to @project, notice: 'Dossier créé avec succès.'
    else
      redirect_to @project, notice: 'Erreur'
    end
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :project_id)
  end

  def current_resource
    @current_resource ||= Folder.find(params[:id]) if params[:id]
  end
end
