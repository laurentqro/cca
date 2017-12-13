class DocumentsController < ApplicationController
  def create
    folder = Folder.find(document_params[:folder_id])
    @document = folder.documents.build(document_params)

    respond_to do |format|
      if @document.save
        format.js
      end
    end
  end

  private

  def document_params
    params.require(:document).permit(:file, :folder_id)
  end
end
