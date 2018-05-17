class FoldersController < ApplicationController

  def show
    @project = Project.find(params[:project_id])
    @subscription = Subscription.find_by(subscribeable_type: "Project",
                                       subscribeable_id: current_resource.id,
                                       user_id: current_user.id)
    @folder = Folder.find(params[:id])
    @child_folder = Folder.new
  end

  def create
    @project = Project.find(params[:project_id])
    @folder = Folder.find(params[:id])
    @child_folder = current_user.folders.build(
      name: folder_params[:name],
      user: current_user,
      project: @project,
      parent: @folder
    )

    if @child_folder.save
      redirect_to project_folder_path(@project, @folder), notice: 'Dossier créé avec succès.'
    else
      render :show
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @folder = Folder.find(params[:id])
  end

  def update
    folder = current_resource

     if folder.update(folder_params)
       redirect_to project_folder_path(folder.project, folder.parent), notice: 'Dossier déplacé avec succès'
     else
       render :edit
     end
  end

  def destroy
    project = Project.find(params[:project_id])
    folder = Folder.find(params[:id])
    parent_folder = folder.parent

    folder.destroy
    redirect_to project_folder_path(project, parent_folder), notice: 'Dossier supprimé avec succès.'
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end

  def current_resource
    @current_resource ||= Folder.find(params[:id]) if params[:id]
  end
end
