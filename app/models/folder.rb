class Folder < ApplicationRecord
  belongs_to :project
  has_many :documents

  validates :name, presence: true

  has_ancestry
end
