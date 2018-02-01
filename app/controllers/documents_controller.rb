class DocumentsController < ApplicationController
  def create
    respond_to do |format|
      if @current_resource.save
        current_user.activities.create(action: "create",
                                       trackable: @current_resource,
                                       project_id: folder.project_id,
                                       folder_id: folder.id)
        format.js
      end
    end
  end

  private

  def document_params
    params.require(:document).permit(:file, :folder_id)
  end

  def current_resource
    @current_resource ||= folder.documents.build(document_params)
  end

  def folder
    @folder ||= Folder.find(document_params[:folder_id])
  end
end
