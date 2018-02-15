class SubfoldersController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @folder = Folder.find(subfolder_params[:parent_id])
    @subfolder = Subfolder.new(subfolder_params)

    if @subfolder.save
      redirect_to project_folder_path(@project, @folder), notice: 'Dossier créé avec succès.'
    else
      redirect_to project_folder_path(@project, @folder), notice: 'Erreur'
    end
  end

  private

  def subfolder_params
    params.require(:subfolder).permit(:name, :parent_id, :project_id)
  end
end
