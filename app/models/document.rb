class Document < ApplicationRecord
  include DocumentUploader::Attachment.new(:file)

  belongs_to :folder
end
