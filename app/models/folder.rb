class Folder < ApplicationRecord
  belongs_to :project
  has_many :documents

  validates :name, presence: true

  has_ancestry

  def has_content?
    documents.exists? || children.exists?
  end
end
