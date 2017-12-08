class Folder < ApplicationRecord
  belongs_to :project
  has_many :documents

  has_ancestry
end
