class Project < ApplicationRecord
  has_many :assignments
  has_many :users, through: :assignments

  validates :name, presence: true
end
