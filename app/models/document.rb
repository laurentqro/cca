class Document < ApplicationRecord
  include DocumentUploader::Attachment.new(:file)

  belongs_to :folder

  validates :file, presence: true
end
