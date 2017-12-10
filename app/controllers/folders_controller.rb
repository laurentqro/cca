class FoldersController < ApplicationController

  def show
    @project = Project.find(params[:project_id])
    @folder = Folder.find(params[:id])
    @subfolder = Subfolder.new
    @document = Document.new
  end

  def create
    @project = Project.find(params[:project_id])
    @folder = @project.folders.build(folder_params)

    if @folder.save
      redirect_to @project, notice: 'Dossier créé avec succès.'
    else
      redirect_to @project, notice: 'Erreur'
    end
  end

  private

  def folder_params
    params.require(:folder).permit(:name)
  end
end