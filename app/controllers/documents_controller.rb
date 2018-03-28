class DocumentsController < ApplicationController
  def create
    respond_to do |format|
      folder = Folder.find(document_params[:folder_id])

      document = current_user.documents.build(
        file: document_params[:file],
        user: current_user,
        folder: folder
      )

      if document.save
        current_user.activities.create(action: "create",
                                       trackable: document,
                                       project_id: folder.project_id,
                                       folder_id: folder.id)
        format.js
      end
    end
  end

  def destroy
    document = Document.find(params[:id])
    folder = document.folder
    project = folder.project

    document.destroy

    redirect_to project_folder_path(project, folder), notice: 'Document supprimé avec succès.'
  end

  private

  def document_params
    params.require(:document).permit(:file, :folder_id)
  end

  def current_resource
    @current_resource ||= Project.find(params[:project_id]) if params[:project_id]
  end
end
