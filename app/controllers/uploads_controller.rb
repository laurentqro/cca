class UploadsController < ApplicationController
  def create
    folder = Folder.find(params[:upload][:folder_id])
    documents = params[:upload][:documents]

    respond_to do |format|
      if documents.present?
        folder.documents.attach(documents)
        format.js
      end
    end
  end
end
