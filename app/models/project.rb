class Project < ApplicationRecord
  has_many :assignments
  has_many :users, through: :assignments

  validates :name, presence: true
  scope :archived, ->{ where(status: "archived") }
  enum status: [ :active, :archived ]
end
