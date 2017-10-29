class Assignment < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validate :user_not_yet_assigned_to_project

  def user_not_yet_assigned_to_project
    if assignment_exists?
      errors[:base] << "Assignment already exists"
    end
  end

  private

  def assignment_exists?
    Assignment.exists?(project_id: project_id, user_id: user_id)
  end
end
