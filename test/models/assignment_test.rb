require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  test 'should validate user not already assigned to the project' do
    Assignment.create(project_id: projects(:pyramid).id, user_id: users(:one).id)
    assignment = Assignment.new(project_id: projects(:pyramid).id, user_id: users(:one).id)

    assignment.valid?

    assert_includes(assignment.errors[:base], 'Utilisateur déjà assigné au projet')
  end
end
