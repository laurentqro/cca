class FoldersController < ApplicationController

  def show
    @project = Project.find(params[:project_id])
    @folder = Folder.find(params[:id])
    @child_folder = Folder.new
    @document = Document.new
  end

  def create
    @project = Project.find(params[:project_id])
    @folder = Folder.find(folder_params[:parent_id])
    @child_folder = Folder.new(folder_params)

    if @child_folder.save
      flash[:notice] = 'Dossier créé avec succès.'
      flash[:class] = 'success'
      redirect_to project_folder_path(@project, @folder)
    else
      render :show
    end
  end

  def destroy
    project = Project.find(params[:project_id])
    folder = Folder.find(params[:id])
    parent_folder = folder.parent

    folder.destroy

    flash[:class] = 'success'
    flash[:notice] = 'Dossier supprimé avec succès.'
    redirect_to project_folder_path(project, parent_folder)
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :project_id, :parent_id)
  end

  def current_resource
    @current_resource ||= Folder.find(params[:id]) if params[:id]
  end
end
