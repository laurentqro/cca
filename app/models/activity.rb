class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :folder
  belongs_to :trackable, polymorphic: true
end
