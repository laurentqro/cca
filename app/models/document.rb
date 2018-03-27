class Document < ApplicationRecord
  include DocumentUploader::Attachment.new(:file)

  belongs_to :folder
  belongs_to :user

  validates :file, presence: true

  def owned_by_user?(user)
    user_id == user.id
  end
end
