require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'all users permissions' do
    permission = Permission.new(nil)
    assert permission.allow_action?(:sessions, :new)
    assert permission.allow_action?(:sessions, :create)
    assert permission.allow_action?(:sessions, :destroy)
  end

  test 'partner permissions' do
    user = users(:one)
    user_project = projects(:one)
    user_project.users << user
    other_project = projects(:two)

    permission = Permission.new(user)

    assert permission.allow_action?(:projects, :show, user_project)
    assert !permission.allow_action?(:projects, :show, other_project)
    assert !permission.allow_action?(:projects, :show)
  end

  test 'employee permissions' do
  end
end
