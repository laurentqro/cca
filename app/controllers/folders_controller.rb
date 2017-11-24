class FoldersController < ApplicationController

  def new
    project = Project.find(params[:project_id])
    @folder = project.folders.build
  end

  def show
    @folder = Folder.find(params[:id])
  end

  def create
    project = Project.find(params[:project_id])
    @folder = project.folders.build(folder_params)

    if @folder.save
      redirect_to project, notice: 'Dossier créé avec succès.'
    else
      render :new
    end
  end

  private

  def folder_params
    params.require(:folder).permit(:name)
  end
end
