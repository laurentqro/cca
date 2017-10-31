require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'name field is required' do
    project = Project.new
    project.save

    project.valid?

    assert_includes(project.errors[:name], "doit être rempli(e)")
  end
end
