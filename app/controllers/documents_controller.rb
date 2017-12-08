class DocumentsController < ApplicationController
  def create
    folder = Folder.find(params[:document][:folder_id])
    @document = folder.documents.build(document_params)

    if @document.save
      redirect_to project_folder_path(folder.project, folder), notice: 'Document envoyé avec succès.'
    else
      redirect_to project_folder_path(folder.project, folder), notice: 'Erreur'
    end
  end

  private

  def document_params
    params.require(:document).permit(:file)
  end
end
