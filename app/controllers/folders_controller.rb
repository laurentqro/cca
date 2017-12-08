class FoldersController < ApplicationController

  def show
    @folder = Folder.find(params[:id])
    @document = Document.new
  end

  def create
    project = Project.find(params[:folder][:project_id])
    @folder = project.folders.build(folder_params)

    if @folder.save
      redirect_to project, notice: 'Dossier créé avec succès.'
    else
      render :new
    end
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end
end
