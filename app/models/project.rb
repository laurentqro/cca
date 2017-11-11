class Project < ApplicationRecord
  has_many :assignments
  has_many :users, through: :assignments

  validates :name, presence: true

  enum status: [ :active, :archived ]

  scope :active,   ->{ where(status: "active") }
  scope :archived, ->{ where(status: "archived") }
end
