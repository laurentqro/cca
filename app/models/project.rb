class Project < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :users, through: :assignments
  has_one :root_folder, ->{ where(ancestry: nil) }, class_name: "Folder", dependent: :destroy

  validates :name, presence: true

  enum status: [ :active, :archived ]

  scope :active,   ->{ where(status: "active") }
  scope :archived, ->{ where(status: "archived") }
end
