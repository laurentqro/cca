require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'all users permissions' do
    permission = Permission.new(nil)
    assert permission.allow_action?('users/sessions', :new)
    assert permission.allow_action?('users/sessions', :create)
  end

  test 'any logged in user permissions' do
    user = users(:one)
    permission = Permission.new(user)

    assert permission.allow_action?('users/registrations', :new)
    assert permission.allow_action?('users/registrations', :create)
    assert permission.allow_action?('users/sessions', :destroy)
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
    user = users(:one)
    user.employee!
    project = projects(:one)

    permission = Permission.new(user)

    assert permission.allow_action?(:projects, :show, project)
    assert permission.allow_action?(:users, :create, project)
    assert permission.allow_action?(:assignments, :create)
    assert permission.allow_action?(:assignments, :destroy)
    assert permission.allow_action?(:archives, :index)
  end
end
