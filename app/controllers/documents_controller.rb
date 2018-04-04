class DocumentsController < ApplicationController
  def create
    respond_to do |format|
      folder = Folder.find(document_params[:folder_id])

      if @current_resource.save
        current_user.activities.create(action:    "create",
                                       trackable: @current_resource,
                                       project:   folder.project,
                                       folder:    folder)
        format.js
      end
    end
  end

  def edit
    @document = current_resource
  end

  def update
    document = current_resource
    destination_folder = Folder.find(document_params[:folder_id])

    if document.update(document_params)
      redirect_to project_folder_path(destination_folder.project, destination_folder), notice: 'Document déplacé avec succès'
    else
      render :edit
    end
  end

  def destroy
    folder = @current_resource.folder
    @current_resource.destroy

    redirect_to project_folder_path(folder.project, folder), notice: 'Document supprimé avec succès.'
  end

  private

  def document_params
    params.require(:document).permit(:file, :folder_id)
  end

  def current_resource
    if params[:id].present?
      @current_resource = Document.find(params[:id])
    else
      @current_resource = current_user.documents.build(
        file: document_params[:file],
        folder: Folder.find(document_params[:folder_id]),
        user: current_user
      )
    end
  end
end
