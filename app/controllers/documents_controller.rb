class DocumentsController < ApplicationController
  def create
    folder = Folder.find(params[:folder_id])
    @document = folder.documents.build(document_params)

    if @document.save
      redirect_to folder, notice: 'Document envoyé avec succès.'
    else
      render 'folders/new'
    end
  end

  private

  def document_params
    params.require(:document).permit(:file)
  end
end
